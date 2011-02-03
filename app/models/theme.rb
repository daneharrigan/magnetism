class Theme < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  has_many :sites
  has_many :templates, :dependent => :destroy
  has_many :template_sets, :dependent => :destroy
end
