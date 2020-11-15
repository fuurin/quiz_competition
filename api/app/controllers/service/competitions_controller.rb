class Service::CompetitionsController < Service::BaseController
  def show
    competition = current_user.competition
    if competition.result?
      render json: {
        user_name: current_user.name,
        user_email: current_user.email,
        status: competition.status,
        title: competition.quiz_set.title,
        total_quiz_num: competition.quiz_set.quizzes.size,
        result: competition.result.to_json
      }
    else
      quiz_set = competition.quiz_set
      quiz = competition.quiz
      options = quiz.options
      answer = current_user.answers.by_quiz(quiz).first
      render json: {
        user_name: current_user.name,
        status: competition.status,
        title: quiz_set.title,
        total_quiz_num: quiz_set.quizzes.size,
        quiz: quiz.to_json(only: %i[number text]),
        options: options.to_json(only: competition.answer? ? %i[id number text is_correct_answer] : %i[id number text]),
        answer: answer&.option&.id,
        image_url: image_url(competition, quiz)
      }
    end
  end

  private

  def image_url(competition, quiz)
    if competition.question? && quiz.image_key.present?
      return Rails.application.credentials.aws[:s3][:bucket_base_url] + quiz.image_key
    end

    if competition.answer? && quiz.answer_image_key.present?
      return Rails.application.credentials.aws[:s3][:bucket_base_url] + quiz.answer_image_key
    end

    nil
  end
end
