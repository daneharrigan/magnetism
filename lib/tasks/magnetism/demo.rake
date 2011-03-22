namespace :m do
  # these tasks should not be known to the user
  # they'll be taken out prior to the initial release
  task :demo => [:user, :site]

  task :user do
    User.create(:login => 'dane', :name => 'Dane Harrigan',
      :email => 'dharrigan@example.com', :password => 'password',
      :password_confirmation => 'password')
  end

  task :site => 'm:demo:theme' do
    site = Site.create(:name => 'Site Name - 1', :domain => 'localhost',
      :theme_id => Theme.first.id)

    Rake::Task['m:demo:pages'].invoke(site)
  end

  namespace :demo do
    task :theme do
      theme = Theme.create(:name => 'Theme Name - 1')
      Rake::Task['m:demo:templates'].invoke(theme)
    end

    task :templates, :theme do |cmd, args|
      theme = args[:theme]
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
        :template_type => TemplateType.page,
        :content => content)

      page = theme.templates.create(
        :name => 'Single Page',
        :template_type => TemplateType.page,
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

    task :pages, :site do |cmd, args|
      site = args[:site]
      theme = Theme.first
      single_page_template = theme.templates.first(:conditions => { :name => 'Single Page' })
      homepage_template = theme.templates.first(:conditions => { :name => 'Homepage' })

      homepage = site.homepage
      homepage.update_attributes(:publish_at => 1.hour.ago, :template => homepage_template)

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
  end
end
