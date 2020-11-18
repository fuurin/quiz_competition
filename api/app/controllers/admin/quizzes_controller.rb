class Admin::QuizzesController < Admin::BaseController
  before_action :set_quiz_set, only: :create

  def create
    ActiveRecord::Base.transaction do
      quizzes = @quiz_set.quizzes
      previous_images = quizzes.each_with_object([]) do |quiz, images|
        images << quiz.image_key << quiz.answer_image_key
      end
      quizzes.destroy_all

      bulk = params['quizzes'].each_with_object({quizzes: [], options: [], image_keys: []}) do |quiz_hash, bulk|
        bulk[:quizzes] << (quiz = @quiz_set.quizzes.new(
          number: quiz_hash['number'],
          text: quiz_hash['text'],
          image_key: image_url_to_key(quiz_hash['image_url']),
          answer_image_key: image_url_to_key(quiz_hash['answer_image_url'])
        ))

        has_answer = false
        quiz_hash['options'].each do |option_hash|
          bulk[:options] << quiz.options.new(
            number: option_hash['number'],
            text: option_hash['text'],
            is_correct_answer: option_hash['is_correct_answer']
          )
          has_answer ||= option_hash['is_correct_answer']
        end
        
        unless has_answer
          raise Admin::QuizMustHaveTheAnswerError
        end

        bulk[:image_keys] << quiz.image_key << quiz.answer_image_key
      end
      Quiz.import! bulk[:quizzes]
      Option.import! bulk[:options]
      delete_unused_images(previous_images, bulk[:image_keys])
      perpetuate_images bulk[:image_keys]
    end
  rescue StandardError => e
    puts e
    render json: { error: e.message }, status: 422
  end

  private

  def set_quiz_set
    unless @quiz_set ||= current_admin.quiz_sets.find_by(id: params['quiz_set_id'])
      render json: { error: 'quiz set not found'}, status: 404
    end
  end

  def image_url_to_key(url)
    url.gsub(Rails.application.credentials.aws[:s3][:bucket_base_url], '')
  end

  def delete_unused_images(previous_keys, current_keys)
    previous_keys.each do |key|
      next if key.blank?
      unless current_keys.include?(key)
        S3_BUCKET.object(key).delete
      end
    end
  end

  def perpetuate_images(image_keys)
    image_keys.each do |key|
      next if key.blank?
      S3_CLIENT.put_object_tagging({
        bucket: Rails.application.credentials.aws[:s3][:bucket],
        key: key,
        tagging: { tag_set: [{ key: 'tmp', value: 'false' }] }
      })
    end
  end
end

class Admin::QuizMustHaveTheAnswerError < StandardError
  def initialize(msg='One question must have at least one correct answer option.')
    super(msg)
  end
end