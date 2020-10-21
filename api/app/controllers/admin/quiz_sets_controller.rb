class Admin::QuizSetsController < ApplicationController
  before_action :authenticate_admin!

  def index
    render json: QuizSet.by_admin(current_admin).pluck(:id, :name)
  end

  def show
  end

  def create
  end

  def update
  end

  def destroy
  end
end
