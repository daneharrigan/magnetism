class Field < ActiveRecord::Base
  validates_presence_of :name, :template_id
  validates_uniqueness_of :name, :scope => :template_id

  belongs_to :template
  # belongs_to :field_type
end
