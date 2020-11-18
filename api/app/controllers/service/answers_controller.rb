class Service::AnswersController < Service::BaseController
  before_action :set_competition

  def index
    render json: {
      status: @competition.status,
      title: @competition.quiz_set.title,
      result: @competition.result.to_json
    }
  end

  def create
    unless @competition.question?
      render json: { error: 'send answer in question phase'}, status: 405
      return
    end

    quiz = @competition.quiz
    option = Option.find_by(id: params[:option_id])
    if (answer = current_user.answers.by_quiz(quiz).first)
      answer.update!(option: option)
      render json: {}, status: 200
    else
      current_user.answers.create!(quiz: quiz, option: option)
      render json: {}, status: 201
    end
  end

  private

  def set_competition
    @competition = current_user.competition
  end
end
