namespace :m do
  desc 'Initial database setup and copying dependent files'
  task :setup => [:schema_load, :seed, :demo]

  desc 'Used to apply schema changes'
  task :update => :environment do
    # get all migrations that havent run yet
    migrated_files = ActiveRecord::Base.connection.execute('SELECT * FROM schema_migrations').map {|s| s['version']}
    migration_directory = "#{Magnetism.root}/db/migrate"

    all_migrations = Dir.glob("#{migration_directory}/*.rb").sort
    migrations_to_run = all_migrations.reject do |m| 
      serial = m.split('/').last.split('_').first

      already_migrated = migrated_files.include?(serial)
      migrated_via_schema_rb = migrated_files.any? { |migrated_serial| serial <= migrated_serial }

      already_migrated || migrated_via_schema_rb
    end

    # run the remaining migrations
    migrations_to_run.each { |migration| require migration }
    migrations_to_run.each do |migration|
      version = migration.match(/\/(\d+)_/)[1].to_i
      ActiveRecord::Migrator.new(:up, "#{Magnetism.root}/db/migrate", version).run
    end
  end

  # these tasks are all "private." They should not be called
  # independently.
  task :schema_load => :environment do
    schema_rb = File.expand_path(File.dirname(__FILE__) + '/../../../db/schema.rb')
    load schema_rb
  end

  task :seed do
    TemplateType.create(:name => 'Page')
    TemplateType.create(:name => 'Snippet')
    TemplateType.create(:name => 'JavaScript')
    TemplateType.create(:name => 'Stylesheet')

    FieldType.create(:name => 'Text field')
    FieldType.create(:name => 'Large text field')
    FieldType.create(:name => 'Asset')
  end

  task :migrate => :environment do
    ActiveRecord::Migration.verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
    ActiveRecord::Migrator.migrate("#{Magnetism.root}/db/migrate/", ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
  end
end
