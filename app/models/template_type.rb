class TemplateType < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :templates

  %W(Page Snippet JavaScript Stylesheet).each do |template_type|
    class_eval <<-STR
      def self.#{template_type.downcase}
        first(:conditions => { :name => "#{template_type}"})
      end
    STR
  end
end
