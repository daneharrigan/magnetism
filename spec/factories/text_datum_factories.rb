Factory.define :text_datum do |f|
  f.sequence(:value) { |n| "Text Value #{n}" }
end
