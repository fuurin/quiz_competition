class Service::CompetitionsController < ApplicationController
  before_action :authenticate_user!
  
  def show
    competition = current_user.competition
    if competition.result?
      result, users_map = competition.result_and_users_map
      render json: {
        status: competition.status,
        title: competition.quiz_set.title
        result: result.to_json,
        users_map: users_map.to_json
      }
    else
      quiz_set = competition.quiz_set
      quiz = competition.quiz
      options = quiz.options
      answer = current_user.answers.by_quiz(quiz).first
      render json: {
        status: competition.status,
        title: quiz_set.title,
        quiz: quiz.to_json(only: %i[number text])
        options: options.to_json(only: competition.answer? ? %i[number text is_correct_answer] : %i[number text]),
        answer: answer.option.number
      }
    end
  end
end
