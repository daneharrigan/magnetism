Factory.define :field do |f|
  f.sequence(:name) { |n| "Field Name - #{n}" }
  f.association :template
end
