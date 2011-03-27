Factory.define :page do |f|
  f.sequence(:title) { |n| "Page Title - #{n}" }
  f.sequence(:slug) { |n| "page-title-#{n}" }
  f.publish_at 1.hour.ago
  f.association :site
  f.association :template, :factory => :template_with_generic_template_type
  f.publish true
end

Factory.define :homepage, :parent => :page do |f|
  f.slug '/'
end

Factory.define :blog_section, :parent => :page do |f|
  f.blog_section true
  f.uri_format ':year/:month/:day/:slug'
end

Factory.define :blog_entry, :parent => :page do |f|
  f.association :parent, :factory => :blog_section
end
