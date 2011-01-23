Factory.define :field do |f|
  f.sequence(:name) { |n| "Field Name - #{n}" }
  f.association :template
  f.association :field_type
end

Factory.define :field_with_text_field, :parent => :field do |f|
  f.association :field_type, :factory => :field_type_text_field
end

Factory.define :field_with_large_text_field, :parent => :field do |f|
  f.association :field_type, :factory => :field_type_large_text_field
end

Factory.define :field_with_asset, :parent => :field do |f|
  f.association :field_type, :factory => :field_type_asset
end
