def mock_site
  mock_model(Site)
end

def mock_theme(args={})
  mock_model(Theme, args)
end

def mock_template
  mock_model(Template, :fields => [])
end

def mock_template_set
  mock_model(TemplateSet)
end

def mock_page(args={})
  mock_model(Page, args)
end
