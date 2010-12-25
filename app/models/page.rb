class Page < ActiveRecord::Base
  include CurrentObject

  belongs_to :site
  belongs_to :parent, :class_name => 'Page'
  belongs_to :template
  has_many :pages, :foreign_key => 'parent_id', :dependent => :destroy

  validates_presence_of :title, :site_id, :template_id
  validates_uniqueness_of :title, :scope => [:site_id, :parent_id]
  validates_uniqueness_of :slug, :scope => [:site_id, :parent_id]

  before_save :generate_slug, :if => Proc.new { |p| !p.slug? }
  before_create :assign_parent, :if => Proc.new { |p| !p.parent_id? }

  delegate :fields, :to => :template

  # has_many :data_sets, :dependent => :destroy

  # validates_presence_of :publish_at # if the page is going active
  # validates_presence_of :template_id
  # validates_format_of :uri_matcher, :with => /\A[a-z\/\-\:]+\z/, :allow_nil => true

  def fields=(values)
    fields.each do |field|
      field.value = values[field.input_name]
    end
  end

  def self.find_by_path(path)
    path = path.split('/')
    path.unshift '/'

    page = first(:conditions => { :slug => path.shift })
    return if page.nil?

    until path.empty? || page.nil?
      page = page.pages.first(:conditions => { :slug => path.shift })
    end

    page
  end

  private
    def generate_slug
      slug = title.downcase.gsub(/[_\s]/,'-').gsub(/([^a-z0-9-])/,'')
      slug.gsub!(/--/,'-') while slug.match(/--/)
      slug.gsub!(/(^-|-$)/,'')

      write_attribute :slug, slug
    end

    def assign_parent
      if site.homepage_id?
        write_attribute :parent_id, site.homepage_id
      end
    end
end
