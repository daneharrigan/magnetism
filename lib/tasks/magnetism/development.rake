namespace :m do
  # these tasks do not have descriptions because they
  # are for gem development only.
  task :development => %W(db:drop m:migrate m:seed db:schema:dump m:javascript) do
    FileUtils.cp("#{Rails.root}/db/schema.rb", "#{Magnetism.root}/db/schema.rb")
  end
end
