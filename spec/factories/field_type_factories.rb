Factory.define :field_type do |f|
  f.sequence(:name) { |n| "Field Type - #{n}" }
end

Factory.define :field_type_text_field, :class => FieldType do |f|
  f.name 'Text field'
end

Factory.define :field_type_large_text_field, :class => FieldType do |f|
  f.name 'Large text field'
end

Factory.define :field_type_asset, :class => FieldType do |f|
  f.name 'Asset'
end
