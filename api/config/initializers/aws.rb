credentials = Aws::Credentials.new(
  Rails.application.credentials.aws[:access_key_id],
  Rails.application.credentials.aws[:secret_access_key]
)

S3_CLIENT = Aws::S3::Client.new(
  credentials: credentials,
  region: Rails.application.credentials.aws[:s3][:region]
)

S3_BUCKET = Aws::S3::Resource.new(
  credentials: credentials,
  region: Rails.application.credentials.aws[:s3][:region]
).bucket(Rails.application.credentials.aws[:s3][:bucket])
