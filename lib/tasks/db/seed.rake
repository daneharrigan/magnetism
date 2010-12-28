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
      :password_confirmation => 'password')
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
    theme = Theme.first
    single_page_template = theme.templates.first(:conditions => { :name => 'Single Page' })
    homepage_template = theme.templates.first(:conditions => { :name => 'Homepage' })

    homepage = site.pages.create(
      :title => 'Homepage',
      :slug => '/',
      :publish_at => 1.hour.ago,
      :template => homepage_template)

    # adding content to homepage fields
    homepage.current!
    homepage.fields = {
      'headline' => %{You're using Magnetism!},
      'features' => %{Theres a lot in store. Stay tuned!},
      'narrative' => %{It's a work-in-progress, but it'll get there.}
    }
    Page.clear_current!

    homepage.pages << site.pages.create(
      :title => 'Page Title - 1',
      :publish_at => 1.hour.ago,
      :template => single_page_template)

    homepage.pages << site.pages.create(
      :title => 'Page Title - 2',
      :publish_at => 1.hour.ago,
      :template => single_page_template)

    ## defining page so i dont need to chain
    ## over and over for sub pages
    page = homepage.pages.last

    page.pages << site.pages.create(
      :title => 'Page Title - 3',
      :publish_at => 1.hour.ago,
      :template => single_page_template)

    site.homepage = homepage
    site.save!
  end

  # dependent tasks
  task :theme do
    Theme.create(:name => 'Theme Name - 1')
    Rake::Task['db:templates'].invoke
  end

  task :templates => [:template_types, :field_types] do
    theme = Theme.first
    content = <<-STR
<html>
<body>
  <h1>Site Name - 1</h1>
  <h2>{{ page.data.headline }}</h2>
  <div id="features">{{ page.data.features }}</div>
  <div id="narrative">{{ page.data.narrative }}</div>
</body>
</html>
    STR

    homepage = theme.templates.create(
      :name => 'Homepage',
      :template_type => TemplateType.template,
      :content => content)

    page = theme.templates.create(
      :name => 'Single Page',
      :template_type => TemplateType.template,
      :content => content)

    # homepage fields
    homepage.fields.create(
      :name => 'Headline',
      :field_type => FieldType.text_field)

    homepage.fields.create(
      :name => 'Features',
      :field_type => FieldType.large_text_field)

    # page fields
    page.fields.create(
      :name => 'Narrative',
      :field_type => FieldType.large_text_field)
  end

  task :template_types do
    TemplateType.create(:name => 'Template')
    TemplateType.create(:name => 'Snippet')
    TemplateType.create(:name => 'JavaScript')
    TemplateType.create(:name => 'Stylesheet')
  end

  task :field_types do
    FieldType.create(:name => 'Text field')
    FieldType.create(:name => 'Large text field')
  end
end
