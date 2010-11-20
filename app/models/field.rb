class Field < ActiveRecord::Base
  validates_presence_of :name, :template_id, :field_type_id
  validates_uniqueness_of :name, :scope => :template_id

  belongs_to :template
  belongs_to :field_type

  before_create :auto_position

  private
    def auto_position
      write_attribute :position, template.fields.count + 1
    end
end
