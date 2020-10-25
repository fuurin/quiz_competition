class Admin::CompetitionsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_quiz_set, only: :create
  before_action :set_competition, except: :create

  def show
    render json: info(@competition.quiz)
  end

  def create
    # 存在したら200返して退会ページへ飛ばす
    render json: { rid: Competition.create!(quiz_set: @quiz_set).rid }, status: 201
  end

  def update
    case @competition.status
    when :question
      to_answer
    when :answer
      (next_quiz = @competition.quiz.next_quiz) ? to_question(next_quiz) : to_result
    when :result
      to_question(@competition.quiz_set.quizzes.first)
    else
      render json: { error: 'invalid competition status' }, status: 422
    end
  end

  def destroy
    @competition.destroy!
  end

  private

  def set_quiz_set
    unless (@quiz_set = QuizSet.by_admin(current_admin).find_by(id: params[:quiz_set_id]))
      render json: { error: 'quiz set not found' }, status: 404
    end

    if @quiz_set.quizzes.size.zero?
      render json: { error: 'quiz set must have at least one quiz' }, status: 422
    end
  end

  def set_competition
    unless (@competition = Competition.find_by(rid: params[:rid]))
      render json: { error: 'competition not found' }, status: 404
    end
  end

  def info(quiz)
    { 
      status: @competition.status.to_s,
      quiz: quiz.to_json(only: %i[number text]),
      options: quiz.options.to_json(only: %i[number text is_correct_answer])
    }
  end

  def to_answer
    competition.update!(status: :answer)
    render json: info(competition.quiz)
  end

  def to_question(next_quiz)
    competition.update!(quiz: next_quiz, status: :question)
    render json: info(quiz)
  end

  def to_result
    competition.update!(status: :result)
    render json: { status: competition.status }
  end
end
