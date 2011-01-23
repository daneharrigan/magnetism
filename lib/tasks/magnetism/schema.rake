namespace :magnetism do
  desc 'Load the Magnetism schema'
  task :schema => :environment do
    schema_rb = File.expand_path(File.dirname(__FILE__) + '/../../../db/schema.rb')
    load schema_rb
  end
end
