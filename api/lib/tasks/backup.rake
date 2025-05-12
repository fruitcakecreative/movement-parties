require "aws-sdk-s3"

namespace :db do
  desc "Backup and upload DB to S3"
  task backup: :environment do
    timestamp = Time.now.utc.strftime("%Y-%m-%d-%H-%M")
    filename = "backup-#{timestamp}.sql"
    filepath = "/tmp/#{filename}"

    system("pg_dump --no-owner --no-acl $DATABASE_URL > #{filepath}")

    s3 = Aws::S3::Resource.new(region: "us-east-1")
    obj = s3.bucket("movement-parties-prod-api-storage").object("db_backups/#{filename}")
    obj.upload_file(filepath)
    puts "Backup uploaded to S3: #{obj.public_url}"
  end
end
