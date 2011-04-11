CarrierWave.configure do |config|
  ### USE THE FILE SYSTEM ###

  config.permissions = 0666
  config.storage = :file

  ### USE S3 STORAGE ###
  #
  #
  #
  #CarrierWave.configure do |config|
  #  config.s3_access_key_id = "xxxxxx"
  #  config.s3_secret_access_key = "xxxxxx"
  #  config.s3_bucket = "my_bucket_name"
  #
  #  # You can change the generated url to a cnamed domain
  #  # by setting the cnamed config:
  #
  #  #config.s3_cnamed = true
  #  #config.s3_bucket = 'bucketname.domain.tld'
  #
  #  # You can specify a region. US Standard "us-east-1" is the default.
  #  # Available options are defined in Fog Storage[http://github.com/geemus/fog/blob/master/lib/fog/aws/storage.rb]
  #  # 'eu-west-1' => 's3-eu-west-1.amazonaws.com'
  #  # 'us-east-1' => 's3.amazonaws.com'
  #  # 'ap-southeast-1' => 's3-ap-southeast-1.amazonaws.com'
  #  # 'us-west-1' => 's3-us-west-1.amazonaws.com'
  #
  #  #config.s3_region = 'eu-west-1'
  #end

  ### USE RACKSPACE CLOUD FILES ###
  #
  #
  #
  #CarrierWave.configure do |config|
  #  config.cloud_files_username = "xxxxxx"
  #  config.cloud_files_api_key = "xxxxxx"
  #  config.cloud_files_container = "my_container"
  #
  #  # You can optionally include your CDN host name in the configuration.
  #  # This is *highly* recommended, as without it every request requires a lookup
  #  # of this information.
  #
  #  #config.cloud_files_cdn_host = "c000000.cdn.rackspacecloud.com"
  #end
end
