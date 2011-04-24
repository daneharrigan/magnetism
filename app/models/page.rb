class Page < ActiveRecord::Base
  include CurrentObject
  include Liquify::Methods

  belongs_to :site
  belongs_to :parent, :class_name => 'Page'
  belongs_to :template
  belongs_to :template_set
  has_many :pages, :foreign_key => 'parent_id', :dependent => :destroy
  has_many :data
  has_many :archives, :foreign_key => :blog_section_id, :order => 'publish_range ASC'
  has_many :comments, :order => 'created_at ASC'
  has_many :redirects

  validates_presence_of :title, :site_id
  validates_uniqueness_of :title, :scope => [:site_id, :parent_id]
  validates_uniqueness_of :slug, :scope => [:site_id, :parent_id]

  before_save :generate_slug, :if => proc { |p| !p.slug? }
  before_create :assign_parent, :if => proc { |p| !p.parent_id? }
  before_create :assign_template, :if => proc { |p| p.blog_section? || p.blog_entry? }
  after_save :update_archive, :if => proc { |p| p.blog_entry? }

  attr_accessor :comment
  alias :comment? :comment

  delegate :fields, :to => :template

  scope :published, lambda { where(['publish = ? AND publish_at <= ?', true, Time.now]) }
  scope :ordered, lambda { |parent| order(parent.blog_section? ? 'publish_at DESC' : 'position ASC') }

  liquify_method :title, :publish_at, :permalink, :blog, :slug, :full_content,
    :archives, :blog_entry?, :close_comments?, :id, :subpages, :homepage?,
    :excerpt  => lambda { |page| Magnetism::ContentParser.new(page.excerpt).invoke },
    :article  => lambda { |page| Magnetism::ContentParser.new(page.article).invoke },
    :data     => lambda { |page| DataDrop.new(page) },
    :comments => lambda { |page| page.comments.excluding_spam }

  def self.find_by_path(request)
    path = request.is_a?(String) ? request : request.fullpath

    if path =~ /\/comments$/ && request.post?
      comment = nil
      path.sub!(/\/comments$/,'')
    else
      comment = false
    end

		if path =~ /feed\.atom$/
			atom_feed = true
			path.sub!(/feed\.atom$/,'')
		else
			atom_feed = false
		end

    if path.length == 1
      path = [path]
    else
      path = path.split('/')
      path[0] = '/'
    end

    page = first(:conditions => { :slug => path.shift })
    return if page.nil?

    until path.empty? || page.nil?
      if page && page.blog_section? && path.present?
        page = find_by_blog(page, path)
        break
      end
      page = page.pages.published.first(:conditions => {:slug => path.shift})
    end

    if page && page.blog_entry?
      date_has_not_passed = page.close_comments_at.nil? || page.close_comments_at > Time.now
      comment = true if comment.nil? && date_has_not_passed && !page.close_comments?
    end

		return if atom_feed && !page.try(:blog_section?)
    page.comment = comment if page

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

  def permalink(full_path=false)
    slugs = []
    page = self

    begin
      unless page.homepage?
        slugs << (page.blog_entry? ? format_blog_slug(page) : page.slug)
      end
    end while page = page.parent

    path = '/' + slugs.reverse.join('/')
		full_path ? "http://#{site.domain}#{path}" : path
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

  def full_content
     html_excerpt << Magnetism::ContentParser.new(article).invoke.to_s
  end

	def html_excerpt
    Magnetism::ContentParser.new(excerpt).invoke.to_s
	end

  def subpages
		pages.published.ordered(self)
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
        end_date = datestamp.length == 3 ? start_date.end_of_day : start_date.end_of_month.end_of_day

        # add the start/end date
        conditional_sql << 'publish_at BETWEEN ? AND ?'
        conditional_values << start_date
        conditional_values << end_date
      end

      conditional_sql = conditional_sql.join(' AND ')
      page.pages.published.first(:conditions => [conditional_sql, *conditional_values])
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

    def update_archive
      return unless publish_changed? || publish_at_changed?
      decrease_date, increase_date = nil

      if publish_at_was
        decrease_date = publish_at_was
      elsif publish_at && publish_changed? && !publish?
        decrease_date = publish_at
      end

      if publish_at && publish? && (publish_changed? || publish_at_changed?)
        increase_date = publish_at
      end

      parent.archives.recount(parent, decrease_date) if decrease_date
      parent.archives.recount(parent, increase_date) if increase_date
    end
end
