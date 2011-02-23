class Template < ActiveRecord::Base
  validates_uniqueness_of :name, :scope => [:theme_id, :template_type_id, :template_set_id]
  validates_presence_of :name, :template_type_id, :theme_id
  validates_numericality_of :template_type_id, :theme_id

  belongs_to :theme
  belongs_to :template_type
  belongs_to :template_set
  has_many :fields, :order => 'position ASC'
  has_many :pages

  scope :pages, lambda { where(:template_type_id => TemplateType.page.id, :template_set_id => nil) }
  scope :snippets, lambda { where(:template_type_id => TemplateType.snippet.id) }
  scope :javascripts, lambda { where(:template_type_id => TemplateType.javascript.id) }
  scope :stylesheets, lambda { where(:template_type_id => TemplateType.stylesheet.id) }
  scope :by_name, lambda { |name| where(:name => name) }

  def destroy?
    !template_set_id?
  end
end
