class Page < ActiveRecord::Base
  include CurrentObject
  include Liquify::Methods

  belongs_to :site
  belongs_to :parent, :class_name => 'Page'
  belongs_to :template
  belongs_to :template_set
  has_many :pages, :foreign_key => 'parent_id', :dependent => :destroy
  has_one :blog

  validates_presence_of :title, :site_id, :template_id
  validates_uniqueness_of :title, :scope => :parent_id
  validates_uniqueness_of :slug, :scope => :parent_id

  before_save :generate_slug, :if => Proc.new { |p| !p.slug? }
  before_create :assign_parent, :if => Proc.new { |p| !p.parent_id? }

  delegate :fields, :to => :template

  liquify_method :title, :publish_at, :permalink, :data => lambda { |page| DataDrop.new(page) }

  # validates_presence_of :publish_at # if the page is going active
  # validates_presence_of :template_id
  # validates_format_of :uri_matcher, :with => /\A[a-z\/\-\:]+\z/, :allow_nil => true

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

  def fields=(values)
    fields.each do |field|
      index = field.input_name
      field.value = values[index] if values[index].present?
    end
  end

  def homepage?
    site.homepage == self
  end

  def permalink
    slugs = []
    page = self

    begin
      unless page.homepage?
        slugs << (page.blog_entry? ? format_blog_slug(page) : page.slug)
      end
    end while page = page.parent

    '/' + slugs.reverse.join('/')
  end

  def publish_at
    read_attribute(:publish_at) || Time.now
  end

  def blog_entry?
    parent.try(:blog_section?)
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

    def format_blog_slug(page)
      uri_format = page.parent.uri_format
      replacements = { :id => page.id, :slug => page.slug,
        :year => '%Y', :month => '%m', :day => '%d'}
      replacements.each { |key, value| uri_format.sub!(":#{key}", value.to_s) }

      page.publish_at.strftime(uri_format)
    end
end
