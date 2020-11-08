class Admin::QuizSetsController < Admin::BaseController
  before_action :set_quiz_set, only: :show

  def index
    render json: current_admin.quiz_sets.to_json(only: %i[id title])
  end

  def show
    render json: { quiz_set: @quiz_set, quizzes: @quiz_set&.quizzes_by_attributes }
  end

  def create
  end

  def update
  end

  def destroy
  end

  private

  def set_quiz_set
    unless (@quiz_set = current_admin.quiz_sets.find_by(id: params[:id]))
      render json: { error: 'quiz set not found' }, status: 404
    end
  end
end
