namespace :magnetism do
  desc 'Setup the Magnetism database'
  task :setup => [:schema, 'db:seed']
end
