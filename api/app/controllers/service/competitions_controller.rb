class Service::CompetitionsController < ApplicationController
  before_action :authenticate_user!
  
  def show
    competition = current_user.competition
    if competition.result?
      result, users_map = competition.result_and_users_map
      render json: {
        user_name: current_user.name,
        status: competition.status,
        title: competition.quiz_set.title,
        total_quiz_num: competition.quiz_set.quizzes.size,
        result: result.to_json,
        users_map: users_map.to_json
      }
    else
      quiz_set = competition.quiz_set
      quiz = competition.quiz
      options = quiz.options
      answer = current_user.answers.by_quiz(quiz).first
      render json: {
        user_name: current_user.name,
        status: competition.status,
        title: quiz_set.title,
        total_quiz_num: quiz_set.quizzes.size,
        quiz: quiz.to_json(only: %i[number text]),
        options: options.to_json(only: competition.answer? ? %i[number text is_correct_answer] : %i[number text]),
        answer: answer&.option&.number
      }
    end
  end
end
