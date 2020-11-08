class Admin::ImageController < Admin::BaseController
  before_action :check_file_size, :check_file_type, :delete_previous_image, only: :upload_url
  before_action :check_quiz_set, only: :temporalize

  # GET /image/upload_url
  # params
  #   file_name
  #   file_size
  #   file_type
  #   quiz_set_id
  #   previous_file_url (optional)
  def upload_url
    options = {
      expires_in: Settings.aws.s3.presigned_url.expires_in,
      acl: 'public-read'
    }
    key = [env_dir, quiz_set_id, file_name].join('/')
    render json: { 
      upload_url: S3_BUCKET.object(key).presigned_url(:put, options),
      key: key,
      url: URI.join(Rails.application.credentials.aws[:s3][:bucket_base_url], key)
    }
  end

  # PUT /image/temporalize
  # params
  #   key
  #
  # tmp=trueタグが付いているファイルを24時間以内に削除するライフサイクルルールを設定することで一時ファイル化する。
  # しかし、Presigned URL でのアップロード時にタグ付けがなぜかできないため、別のリクエストによってタグ付けを行う。
  # https://github.com/aws/aws-sdk-js/issues/1313
  # https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/S3/Client.html#put_object_tagging-instance_method
  def temporalize
    S3_CLIENT.put_object_tagging({
      bucket: Rails.application.credentials.aws[:s3][:bucket],
      key: params[:key],
      tagging: { tag_set: [{ key: 'tmp', value: 'true' }] }
    })
  rescue StandardError => e
    render json: { error: e.message }, status: 400
  end

  private

  def check_file_size
    return if params[:file_size].present? && params[:file_size].to_i <= Settings.controllers.image_upload.max_file_size

    render json: { message: 'maximum file size is 1MB' }, status: 400
  end

  def check_file_type
    return if Settings.controllers.image_upload.allowed_file_types.include?(params[:file_type])

    render json: { message: "allowed file types are png, jpg, and jpeg. But #{params[:file_type]} passed." }, status: 400
  end

  def delete_previous_image
    return if params[:previous_file_url].blank?

    key = URI.parse(params[:previous_file_url]).path.slice(1..)

    unless current_admin.quiz_sets.find_by(id: key.split('/').second.to_i).present?
      render json: { error: 'quiz set for the key not found' }, status: 400 and return
    end

    S3_BUCKET.object(key).delete
  rescue Aws::S3::Errors::NoSuchKey => e
  end

  def check_quiz_set
    unless current_admin.quiz_sets.find_by(id: params[:key].split('/').second.to_i).blank?
      return
    end

    render json: { error: 'quiz set for the key not found' }, status: 400
  end

  def env_dir
    Rails.env.production? ? 'prod' : 'dev'
  end

  def quiz_set_id
    if params[:quiz_set_id].blank? || current_admin.quiz_sets.find_by(id: params[:quiz_set_id]).blank?
      render json: { message: 'valid quiz set id must be passed' }, status: 400
    end

    params[:quiz_set_id]
  end

  def file_name
    if params[:file_name].size > Settings.controllers.image_upload.max_file_name_size
      render json: { message: "maximum file_name length is #{Settings.controllers.image_upload.max_file_name_size}" }, status: 400
    end

    [Time.current.strftime('%Y%m%d%H%M%S'), SecureRandom.alphanumeric(16), params[:file_name]].join('_')
  end
end
