class Service::AnswersController < ApplicationController
  before_action :authenticate_user!

  def index
    competition = current_user.competition
    render json: {
      status: competition.status,
      title: competition.quiz_set.title,
      result: competition.result.to_json
    }
  end

  def create
    competition = current_user.competition
    unless competition.question?
      render json: { error: 'send answer in question phase'}, status: 405
      return
    end

    quiz = competition.quiz
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
