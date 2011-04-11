Magnetism.setup do |config|
  config.cache = :file_system
  # Or use varnish caching. If you are hosting with Heroku,
  # enable varnish.
  #config.cache = :varnish
  #
  # 5 minutes (300 seconds) is an average caching time.
  # increase the cache_length if you want your pages cached
  # for longer periods of time.
  #config.cache_length = 300
  #
  #
  config.defensio_key = ENV['DEFENSIO_KEY']
end
