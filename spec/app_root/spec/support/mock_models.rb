def mock_site
  mock_model(Site)
end

def mock_template
  mock_model(Template, :fields => [])
end
