fpo_file_path = File.expand_path(File.dirname(__FILE__) + '/../support/carrierwave')

Factory.define :asset do |f|
  f.sequence(:description) { |n| "Asset Description - #{n}" }
  f.association :site
end

Factory.define :asset_with_file, :parent => :asset do |f|
  f.file File.open("#{fpo_file_path}/fpo.gif")
end
