Factory.define :page do |f|
  f.sequence(:title) { |n| "Page Title - #{n}" }
  f.sequence(:slug) { |n| "page-title-#{n}" }
  f.publish_at 1.hour.ago
  f.association :site
  f.association :template, :factory => :template_with_generic_template_type
end

Factory.define :homepage, :parent => :page do |f|
  f.slug '/'
end
