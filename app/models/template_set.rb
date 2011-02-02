class TemplateSet < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :templates
  belongs_to :theme
end