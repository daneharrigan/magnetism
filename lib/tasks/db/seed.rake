namespace :db do
  task :seed do
    Rake::Task['db:user'].invoke
    Rake::Task['db:site'].invoke
  end
  
  # all of the peices being seeded. this keeps the
  # rake tasks clean and with a single purpose

  task :user do
    User.create(
      :login => 'dane',
      :name => 'Dane Harrigan',
      :email => 'dharrigan@example.com',
      :password => 'password',
      :password_confirmation => 'password',
      :email_confirmed => true)
  end

  task :site => :theme do
    site = Site.create(
      :name => 'Site Name - 1',
      :domain => 'localhost',
      :theme_id => Theme.first.id)

    Rake::Task['db:pages'].invoke
  end

  task :pages do
    site = Site.first

    homepage = site.pages.create(
      :title => 'Homepage',
      :slug => '/',
      :publish_at => 1.hour.ago)

    homepage.pages << site.pages.create(
      :title => 'Page Title - 1',
      :publish_at => 1.hour.ago)

    homepage.pages << site.pages.create(
      :title => 'Page Title - 2',
      :publish_at => 1.hour.ago)

    ## defining page so i dont need to chain
    ## over and over for sub pages
    page = homepage.pages.last

    page.pages << site.pages.create(
      :title => 'Page Title - 3',
      :publish_at => 1.hour.ago)

    site.homepage = homepage
    site.save!
  end

  # dependent tasks
  task :theme do
    Theme.create(:name => 'Theme Name - 1')
    Rake::Task['db:template'].invoke
  end

  task :template => :template_types do
    theme = Theme.first
    content = <<-STR
<html>
<body>
  <h1>Site Name - 1</h1>
</body>
</html>
    STR

    theme.templates.create(
      :name => 'Homepage',
      :template_type => TemplateType.template,
      :content => content)
  end

  task :template_types do
    TemplateType.create(:name => 'Template')
    TemplateType.create(:name => 'Snippet')
    TemplateType.create(:name => 'JavaScript')
    TemplateType.create(:name => 'Stylesheet')
  end
end