Factory.define :theme do |f|
  f.sequence(:name) { |n| "Theme Name - #{n}" }
end