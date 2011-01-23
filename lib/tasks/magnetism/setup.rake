namespace :magnetism do
  desc 'Setup the Magnetism database'
  task :setup => :environment do
    schema_rb = File.expand_path(File.dirname(__FILE__) + '/../../../db/schema.rb')
    load schema_rb
    Rake::Task['db:seed'].invoke
  end
end
