class Admin::QuizSetsController < ApplicationController
  before_action :authenticate_admin!

  def index
    render json: QuizSet.by_admin(current_admin)
  end

  def show
    quiz_set = QuizSet.by_admin(current_admin).find_by(id: params[:id])
    render json: { quiz_set: quiz_set, quizzes: quiz_set&.quizzes_by_attributes }
  end

  def create
  end

  def update
  end

  def destroy
  end
end
