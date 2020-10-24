class Admin::QuizSetsController < ApplicationController
  before_action :authenticate_admin!

  def index
    render json: current_admin.quiz_sets
  end

  def show
    quiz_set = current_admin.quiz_sets.find_by(id: params[:id])
    render json: { quiz_set: quiz_set, quizzes: quiz_set&.quizzes_by_attributes }
  end

  def create
  end

  def update
  end

  def destroy
  end
end
