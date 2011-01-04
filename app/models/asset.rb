class Asset < ActiveRecord::Base
  belongs_to :site
  validates_presence_of :site_id, :file
  mount_uploader :file, FileUploader
end
