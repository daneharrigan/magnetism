namespace :m do
  desc 'Initial database setup and copying dependent files'
  task :setup => [:schema_load, :seed, :javascript]

  desc 'Used to apply schema changes and update dependent files'
  task :update => [:migrate, :javascript]

  # these tasks are all "private." They should not be called
  # independently.
  task :schema_load => :environment do
    schema_rb = File.expand_path(File.dirname(__FILE__) + '/../../../db/schema.rb')
    load schema_rb
  end

  task :seed => 'db:seed'

  task :javascript do
    FileUtils.cp_r "#{Magnetism.root}/public/admin", "#{Rails.root}/public"
  end

  task :migrate => :environment do
    ActiveRecord::Migration.verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
    ActiveRecord::Migrator.migrate("#{Magnetism.root}/db/migrate/", ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
  end
end
