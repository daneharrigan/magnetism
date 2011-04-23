def mock_site(args={})
  options = {:pages => []}.merge(args)
  mock_model(Site, options)
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
  options = {:comment? => false}.merge(args)
  mock_model(Page, options)
end

def mock_request(args)
  args['post?'] ||= false
  Struct.new(*args.keys).new(*args.values)
end
