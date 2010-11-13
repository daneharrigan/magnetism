Factory.define :page do |f|
  f.sequence(:title) { |n| "Page Title - #{n}" }
  f.sequence(:slug) { |n| "page-title-#{n}" }
  f.publish_at 1.hour.ago
  f.association :site
end