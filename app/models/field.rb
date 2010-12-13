class Field < ActiveRecord::Base
  validates_presence_of :name, :template_id, :field_type_id
  validates_uniqueness_of :name, :scope => :template_id

  belongs_to :template
  belongs_to :field_type
  has_many :data

  before_create :auto_position

  def value
    # will need to do Page.current or something like that
    entry = data.first(:conditions => { :page_id => Page.current.id }).try(:entry)
    entry ? entry.value : nil
  end

  private
    def auto_position
      write_attribute :position, template.fields.count + 1
    end
end
