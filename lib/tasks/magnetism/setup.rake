namespace :m do
  desc 'Initial database setup and copying dependent files'
  task :setup => [:schema_load, :seed, :javascript, :demo]

  desc 'Used to apply schema changes and update dependent files'
  task :update => :javascript

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

  task :javascript do
    FileUtils.cp_r "#{Magnetism.root}/public/admin", "#{Rails.root}/public"
  end

  task :migrate => :environment do
    puts ActiveRecord::Migrator.current_version
    #ActiveRecord::Migration.verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
    #ActiveRecord::Migrator.migrate("#{Magnetism.root}/db/migrate/", ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
  end
end
