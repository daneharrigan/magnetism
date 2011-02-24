class Page < ActiveRecord::Base
  include CurrentObject
  include Liquify::Methods

  belongs_to :site
  belongs_to :parent, :class_name => 'Page'
  belongs_to :template
  belongs_to :template_set
  has_many :pages, :foreign_key => 'parent_id', :dependent => :destroy
  has_one :blog, :dependent => :destroy

  validates_presence_of :title, :site_id
  validates_presence_of :template_id, :unless => Proc.new { |p| p.blog_section? || p.blog_entry? }
  validates_uniqueness_of :title, :scope => :parent_id
  validates_uniqueness_of :slug, :scope => :parent_id

  before_save :generate_slug, :if => Proc.new { |p| !p.slug? }
  before_create :assign_parent, :if => Proc.new { |p| !p.parent_id? }
  before_create :assign_template, :if => Proc.new { |p| p.blog_section? || p.blog_entry? }
  after_create :create_blog, :if => Proc.new { |p| p.blog_entry? }

  accepts_nested_attributes_for :blog

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
      return find_by_blog(page, path) if page && page.blog_section? && path.present?
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

  def cache_path
    "#{Rails.public_path}/cache/#{site.domain}#{permalink}.html"
  end

  private
    def self.find_by_blog(page, path)
      regex = page.uri_format.sub(':id','(\d+)').sub(':year','(\d{4})').gsub(/:month|:day/,'(\d{2})').sub(':slug','([a-z0-9_-]+)')
      path = path.join('/')

      return unless path =~ /\A#{regex}\z/

      keys = page.uri_format.scan(/:+([:a-z]+)/)
      values = path.match(/\A#{regex}\z/).to_a
      values.shift
      args = Hash[*keys.zip(values).flatten].with_indifferent_access

      # add the slug
      conditional_sql = ['slug = ?']
      conditional_values = [args[:slug]]

      # add id
      if args[:id]
        conditional_sql << 'id = ?'
        conditional_values << args[:id]
      end

      datestamp = [args[:year], args[:month], args[:day]].compact
      if datestamp.present?
        start_date = Date.civil(*datestamp.map(&:to_i))
        end_date = datestamp.length == 3 ? start_date.end_of_day : start_date.end_of_month

        # add the start/end date
        conditional_sql << 'publish_at BETWEEN ? AND ?'
        conditional_values << start_date
        conditional_values << end_date
      end

      conditional_sql = conditional_sql.join(' AND ')
      page.pages.first(:conditions => [conditional_sql, *conditional_values])
    end 

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

    def assign_template
      template = if blog_section?
        template_set.templates.by_name('Index').first
      else
        parent.template_set.templates.by_name('Post').first
      end

      write_attribute :template_id, template.id
    end

    def format_blog_slug(page)
      uri_format = page.parent.uri_format.clone
      replacements = { :id => page.id, :slug => page.slug,
        :year => '%Y', :month => '%m', :day => '%d'}
      replacements.each { |key, value| uri_format.sub!(":#{key}", value.to_s) }

      page.publish_at.strftime(uri_format)
    end
end
