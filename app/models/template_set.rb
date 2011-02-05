class TemplateSet < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :templates, :dependent => :destroy
  has_many :pages
  belongs_to :theme

  after_create :dependent_templates

   private
    def dependent_templates
      # create Index
      templates.create(:name => 'Index',
        :template_type => TemplateType.page,
        :theme => theme)

      # create Post
      templates.create(:name => 'Post',
        :template_type => TemplateType.page,
        :theme => theme)
    end
end
