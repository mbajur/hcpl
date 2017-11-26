require 'dragonfly'
require 'dragonfly/s3_data_store'

# Configure
Dragonfly.app.configure do
  plugin :imagemagick

  secret ENV['DRAGONFLY_SECRET'] || "6858178dc2dd7dda12c82a8337484b330d85ff561fb0f8ed51943e6a1393f05b"

  url_format "/media/:job/:name"

  # That's a working code but creating a file throws 403 Forbidden on amazon side
  # datastore :s3,
  #   access_key_id: ENV['S3_ACCESS_KEY_ID'],
  #   secret_access_key: ENV['S3_SECRET_ACCESS_KEY'],
  #   bucket_name: ENV['S3_BUCKET_NAME'],
  #   region: 'eu-central-1'

  root_path = Rails.env.development? ? Rails.root.join('public/system/dragonfly', Rails.env) : '/storage/dragonfly'
  datastore :file,
    root_path: root_path,
    server_root: Rails.root.join('public')

  # if Rails.env.development?
  #   datastore :file,
  #     root_path: Rails.root.join('public/system/dragonfly', Rails.env),
  #     server_root: Rails.root.join('public')
  # else
  #   datastore :s3,
  #     bucket_name: ENV['S3_BUCKET_NAME'],
  #     access_key_id: ENV['S3_ACCESS_KEY_ID'],
  #     secret_access_key: ENV['S3_SECRET_ACCESS_KEY']
  # end
end

# Logger
Dragonfly.logger = Rails.logger

# Mount as middleware
Rails.application.middleware.use Dragonfly::Middleware

# Add model functionality
if defined?(ActiveRecord::Base)
  ActiveRecord::Base.extend Dragonfly::Model
  ActiveRecord::Base.extend Dragonfly::Model::Validations
end
