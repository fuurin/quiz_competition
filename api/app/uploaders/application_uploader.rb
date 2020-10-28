class ApplicationUploader < CarrierWave::Uploader::Base
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def presigned_url(file_name = nil)
    file_name ||= self.model.attributes[mounted_as.to_s]
    object = S3_BUCKET.object([store_dir, file_name].join('/'))
    # 署名付きリンクは10分で失効させる(デフォルトでは15分)
    object.presigned_url(:put, expires_in: 10.minutes.to_i, acl: 'private')
  end
end
