require "aws-sdk-s3"

namespace :s3 do
  desc "Upload image to S3"
  task :upload, [:file_path, :type] => :environment do |_, args|
    type = args[:type] || "misc"
    folder = case type
             when "user" then "users"
             when "event" then "events"
             when "venue" then "venues"
             else "misc"
             end

    s3 = Aws::S3::Resource.new(region: "us-east-1")
    bucket = s3.bucket("movement-parties-assets")

    file = args[:file_path]
    name = File.basename(file)
    obj = bucket.object("#{folder}/#{name}")
    obj.upload_file(file, acl: "public-read")

    puts "Uploaded to: #{obj.public_url}"
  end
end
