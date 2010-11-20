Factory.define :field_type do |f|
  f.sequence(:name) { |n| "Field Type - #{n}" }
end
