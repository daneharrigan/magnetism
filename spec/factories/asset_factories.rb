Factory.define :asset do |f|
  f.sequence(:description) { |n| "Asset Description - #{n}" }
  f.association :site
end
