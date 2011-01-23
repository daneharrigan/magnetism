Factory.define :string_datum do |f|
  f.sequence(:value) { |n| "String Value #{n}" }
end
