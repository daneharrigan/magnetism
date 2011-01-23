Factory.define :template_type do |f|
  f.sequence(:name) { |n| "Template Type - #{n}" }
end

Factory.define :template_type_page, :parent => :template_type do |f|
  f.name 'Page'
end

Factory.define :template_type_snippet, :parent => :template_type do |f|
  f.name 'Snippet'
end

Factory.define :template_type_javascript, :parent => :template_type do |f|
  f.name 'JavaScript'
end

Factory.define :template_type_stylesheet, :parent => :template_type do |f|
  f.name 'Stylesheet'
end
