Factory.define :template do |f|
  f.sequence(:name) { |n| "Template Name - #{n}"}
  f.association :theme
  f.association :template_type, :factory => :template_type_page
end

Factory.define :template_with_generic_template_type, :parent => :template do |f|
  f.association :template_type
end

Factory.define :snippet, :parent => :template do |f|
  f.association :template_type, :factory => :template_type_snippet
end

Factory.define :javascript, :parent => :template do |f|
  f.association :template_type, :factory => :template_type_javascript
end

Factory.define :stylesheet, :parent => :template do |f|
  f.association :template_type, :factory => :template_type_stylesheet
end
