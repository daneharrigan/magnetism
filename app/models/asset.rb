class Asset < ActiveRecord::Base
  mount_uploader :file, FileUploader

  belongs_to :site
  validates_presence_of :site_id

  alias :value= :file=
  alias :value :file
end
