namespace :magnetism do
  desc 'Setup the Magnetism database'
  task :setup => [:schema, 'db:seed', :admin_directory]

  desc 'Copies the public/admin directory from Magnetism to rails root public'
  task :admin_directory do
    FileUtils.cp_r "#{Magnetism.root}/public/admin", "#{Rails.root}/public"
  end
end
