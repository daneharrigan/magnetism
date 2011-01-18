class Asset < ActiveRecord::Base
  mount_uploader :file, FileUploader

  belongs_to :site
  has_many :data, :as => :entry, :dependent => :destroy
  validates_presence_of :site_id

  alias :value= :file=
  alias :value :file
end
