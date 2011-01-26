require 'magnetism/engine'
require 'magnetism/page_not_found'

# gems
require 'haml'
require 'devise'
require 'inherited_resources'
require 'layout_options'
require 'current_object'
require 'liquify'
require 'fog'
require 'mini_magick'
require 'carrierwave'

# Magnetism.setup do |s|
#   # write files to the local filesystem
#   s.storage = :file
#
#   # keep files on s3
#   s.storage = :s3
    #
    #     CarrierWave.configure do |config|
    #       config.s3_access_key_id = "xxxxxx"
    #       config.s3_secret_access_key = "xxxxxx"
    #       config.s3_bucket = "my_bucket_name"
    #       config.s3_cnamed = true
    #       config.s3_bucket = 'bucketname.domain.tld'
    #       config.s3_region = 'eu-west-1'

#   s.storage :cloud_files
    #     CarrierWave.configure do |config|
    #       config.cloud_files_username = "xxxxxx"
    #       config.cloud_files_api_key = "xxxxxx"
    #       config.cloud_files_container = "my_container"
    #       config.cloud_files_cdn_host = "c000000.cdn.rackspacecloud.com"
#
#   SIMILARITIES:
#     api_key
#     secret
# end

module Magnetism
  def self.setup
    yield(self)
  end

  def self.root
    File.expand_path(File.dirname(__FILE__) + '/..')
  end
end

