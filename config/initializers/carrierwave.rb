CarrierWave.configure do |config|
  config.permissions = 0666
  config.storage = :file
end
