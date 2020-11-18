class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  protected

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
