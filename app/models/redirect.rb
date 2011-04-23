class Redirect < ActiveRecord::Base
  belongs_to :page
  belongs_to :site

  validates_presence_of :page_id
  validates_presence_of :site_id
  validates_presence_of :url
end
