class Field < ActiveRecord::Base
  validates_presence_of :name, :template_id, :field_type_id
  validates_uniqueness_of :name, :scope => :template_id

  belongs_to :template
  belongs_to :field_type
  has_many :data

  before_create :auto_position

  def self.[](key)
    all.detect { |field| field.input_name == key }.try(:value)
  end

  def value
    entry.try(:value)
  end

  def value=(val)
    # kill the asset when you're replacing it
    if FieldType.asset == field_type && entry
      entry.destroy
    end

    if value.nil?
      datum = case field_type
        when FieldType.text_field
          StringDatum.create(:value => val)
        when FieldType.large_text_field
          TextDatum.create(:value => val)
        when FieldType.asset
          asset = Asset.create(:site => Site.current)
          asset.file = val
          asset.save!
          asset
      end

      data.create(:page => Page.current, :entry => datum)
      return datum
    else
      # DH: need to set entry to something because I cant update a value
      # through a select action (eg: Datum.first, Datum.find)
      datum = entry
      datum.value = val
      datum.save!
    end
  end

  def input_name
    name.downcase.gsub(/(\s|\-)/,'_').gsub(/\./,'')
  end

  def entry
    data.first(:conditions => { :page_id => Page.current.id }).try(:entry)
  end

  private
    def auto_position
      write_attribute :position, template.fields.count + 1
    end
end
