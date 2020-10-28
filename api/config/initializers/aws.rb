credentials = Aws::Credentials.new(
  Rails.application.credentials.aws[:access_key_id],
  Rails.application.credentials.aws[:secret_access_key]
)

s3_resource = Aws::S3::Resource.new(
  region: Rails.application.credentials.aws[:s3][:region],
  credentials: credentials
)

S3_BUCKET = s3_resource.bucket(
  Rails.application.credentials.aws[:s3][:bucket][Rails.env.production? ? :prod : :dev]
)