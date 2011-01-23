Factory.define :asset do |f|
  f.sequence(:description) { |n| "Asset Description - #{n}" }
  f.association :site
end

Factory.define :asset_with_file, :parent => :asset do |f|
  f.file File.open(support_image_path('carrierwave/fpo.gif'))
end
