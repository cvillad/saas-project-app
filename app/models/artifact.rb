class Artifact < ApplicationRecord
  before_save :upload_to_s3
  attr_accessor :upload
  belongs_to :projects

  MAX_FILESIZE = 10.megabytes
  validates_presence_of :name, :upload 
  validates_uniqueness_of :name

  validate :uploaded_file_size

  private
  def uploaded_file_size
    if upload
      errors.add(:upload, "File size must be less than #{self.class::MAX_FILESIZE}") unless upload.size <= self.class::MAX_FILESIZE
    end
  end

  def upload_to_s3
    puts "lol"
    begin 
      bucket_name = ENV["S3_BUCKET"]
      s3_client = Aws::S3::Resource.new(region: ENV["AWS_REGION"],
                                        access_key_id: ENV["AWS_ACCESS_KEY_ID"],
                                        secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"])
      puts "AJÁ: #{s3_client}"
      puts "#{Tenant.find(Thread.current[:tenant_id]).name}/#{upload.original_filename}"
      object_key = "#{Tenant.find(Thread.current[:tenant_id]).name}/#{upload.original_filename}"
      puts "#{object_key}"
      object = s3_client.bucket(bucket_name).object(object_key)
      puts "OBJECT: #{object}"
      object.upload_file(upload.path, acl: "public-read")
      puts "#{object}"
      self.key = object.public_url
    rescue StandardError => e
      puts "Error uploading object: #{e.message}"
    end
  end

end
