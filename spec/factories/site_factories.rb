Factory.define :site do |f|
  f.sequence(:name) { |n| "Site Name - #{n}" }
  f.sequence(:domain) { |n| "site-name-#{n}.com" }
  f.association :theme
end