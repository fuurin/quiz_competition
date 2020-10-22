class Admin::QuizSetsController < ApplicationController
  before_action :authenticate_admin!

  def index
    render json: QuizSet.by_admin(current_admin)
  end

  def show
    quiz_set = QuizSet.by_admin(current_admin).find(params[:id])
    render json: { quiz_set: quiz_set }
  end

  def create
  end

  def update
  end

  def destroy
  end
end
