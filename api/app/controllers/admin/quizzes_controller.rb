class Admin::QuizzesController < ApplicationController
  def create
    quiz_set = current_admin.quiz_sets.find_by(id: params['quiz_set']['id'])
    unless quiz_set
      render json: { error: 'quiz set not found'}, status: 422
    end

    begin
      ActiveRecord::Base.transaction do
        quiz_set.quizzes.destroy_all

        bulk = params['quizzes'].each_with_object({quizzes: [], options: []}) do |quiz_hash, bulk|
          bulk[:quizzes] << (quiz = Quiz.new(
            quiz_set: quiz_set,
            number: quiz_hash['number'],
            text: quiz_hash['text'],
            image: quiz_hash['image']['url'],
            answer_image: quiz_hash['answer_image']['url']
          ))

          puts quiz

          has_answer = false
          quiz_hash['options'].each do |option_hash|
            bulk[:options] << (option = Option.new(
              quiz: quiz,
              number: option_hash['number'],
              text: option_hash['text'],
              is_correct_answer: option_hash['is_correct_answer']
            ))
            has_answer ||= option.is_correct_answer
          end
          
          unless has_answer
            raise QuizMustHaveAnswerError
          end
        end
        Quiz.import! bulk[:quizzes]
        Option.import! bulk[:options]
      end
    rescue StandardError => e
      puts e
      render json: { error: e.message }, status: 422
    end
  end

  class QuizMustHaveAnswerError < StandardError
    def initialize(msg='One question must have at least one correct answer option.')
      super(msg)
    end
  end
end
