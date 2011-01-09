class Template < ActiveRecord::Base
  validates_uniqueness_of :name, :scope => [:theme_id, :template_type_id]
  validates_presence_of :name, :template_type_id, :theme_id
  validates_numericality_of :template_type_id, :theme_id

  belongs_to :theme
  belongs_to :template_type
  has_many :fields, :order => 'position ASC'
  has_many :pages

  scope :pages, lambda { where(:template_type_id => TemplateType.page.id) }
  scope :snippets, lambda { where(:template_type_id => TemplateType.snippet.id) }
  scope :javascripts, lambda { where(:template_type_id => TemplateType.javascript.id) }
  scope :stylesheets, lambda { where(:template_type_id => TemplateType.stylesheet.id) }
end
