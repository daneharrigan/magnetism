namespace :m do
  # these tasks do not have descriptions because they
  # are for gem development only.
  task :development => %W(db:drop m:migrate m:seed db:schema:dump) do
    FileUtils.cp("#{Rails.root}/db/schema.rb", "#{Magnetism.root}/db/schema.rb")
  end

  task :migration, :name do |cmd, args|
    timestamp = Time.now.strftime('%Y%m%d%H%M%S')
    FileUtils.touch("#{Magnetism.root}/db/migrate/#{timestamp}_#{args[:name]}.rb")
  end

  namespace :test do
    task :prepare => %W(m:development db:test:prepare)
  end
end
