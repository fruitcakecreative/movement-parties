
class Venue < ApplicationRecord
  has_many :events
  has_one_attached :logo

  def logo_url
    return nil unless logo.attached?

    Aws::S3::Object.new(
      bucket_name: ::ENV.fetch("AWS_BUCKET"),
      key: logo.blob.key,
      client: Aws::S3::Client.new
    ).public_url
  end

end
