class Asset < ActiveRecord::Base
  mount_uploader :file, FileUploader
end
