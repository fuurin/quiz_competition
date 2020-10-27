class Admin::CompetitionsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_quiz_set, only: :create
  before_action :set_competition, except: :create

  def show
    render json: @competition.result? ? result_info : quiz_info(@competition.quiz)
  end

  def create
    if (competition = Competition.find_by(quiz_set: @quiz_set))
      render json: { rid: competition.rid }, status: 200
    else
      render json: { rid: Competition.create!(quiz_set: @quiz_set).rid }, status: 201
    end
  end

  def update
    case @competition.status.to_sym
    when :question
      to_answer
    when :answer
      (next_quiz = @competition.quiz.next_quiz) ? to_question(next_quiz) : to_result
    when :result
      @competition.answers.destroy_all
      to_question(@competition.quiz_set.quizzes.first)
    else
      render json: { error: 'invalid competition status' }, status: 422
    end
  end

  def destroy
    @competition.destroy!
  end

  private

  def set_quiz_set
    unless (@quiz_set = current_admin.quiz_sets.find_by(id: params[:quiz_set_id]))
      render json: { error: 'quiz set not found' }, status: 404
    end

    if @quiz_set.quizzes.size.zero?
      render json: { error: 'quiz set must have at least one quiz' }, status: 422
    end
  end

  def set_competition
    unless (@competition = Competition.find_by(rid: params[:rid]))
      render json: { error: 'competition not found' }, status: 404
    end
  end

  def quiz_info(quiz)
    { 
      status: @competition.status.to_s,
      title: @competition.quiz_set.title,
      total_quiz_num: @competition.quiz_set.quizzes.size,
      quiz: quiz.to_json(only: %i[number text]),
      options: quiz.options.to_json(only: %i[number text is_correct_answer])
    }
  end

  def result_info
    {
      status: @competition.status, 
      title: @competition.quiz_set.title,
      total_quiz_num: @competition.quiz_set.quizzes.size,
      result: @competition.result.to_json
    }
  end

  def to_answer
    @competition.update!(status: :answer)
    render json: quiz_info(@competition.quiz)
  end

  def to_question(next_quiz)
    @competition.update!(quiz: next_quiz, status: :question)
    render json: quiz_info(next_quiz)
  end

  def to_result
    @competition.update!(status: :result)
    render json: result_info
  end
end
