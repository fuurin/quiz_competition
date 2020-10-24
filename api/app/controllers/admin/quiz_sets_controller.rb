class Admin::QuizSetsController < ApplicationController
  before_action :authenticate_admin!

  def index
    render json: QuizSet.by_admin(current_admin)
  end

  def show
    quiz_set = QuizSet.by_admin(current_admin).find(params[:id])
    quizzes = Quiz.by_set(quiz_set).each_with_object([]) do |quiz, a|
    end
    render json: { quiz_set: quiz_set, quizzes: quizzes }
  end

  def create
  end

  def update
  end

  def destroy
  end
end
