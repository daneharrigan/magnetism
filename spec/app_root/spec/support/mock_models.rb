def mock_site(args={})
  mock_model(Site, args)
end

def mock_theme(args={})
  mock_model(Theme, args)
end

def mock_template(args={})
  args[:fields] ||= {}
  mock_model(Template, args)
end

def mock_template_set
  mock_model(TemplateSet)
end

def mock_page(args={})
  mock_model(Page, args)
end
