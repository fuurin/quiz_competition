class Service::AnswersController < ApplicationController
  before_action :authenticate_user!

  def index
    competition = current_user.competition
    result, users_map = competition.result_and_users_map
    render json: {
      status: competition.status,
      title: competition.quiz_set.title
      result: result.to_json,
      users_map: users_map.to_json
    }
  end

  def create
    quiz = current_user.competition.quiz
    option = Option.find_by(id: params[:option_id])
    if (answer = Answer.by_user(current_user).by_quiz(quiz).first)
      answer.update!(option: option)
      render json: {}, status: 200
    else
      Answer.create!(user: current_user, quiz: quiz, option: option)
      render json: {}, status: 201
    end
  end
end
