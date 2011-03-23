require 'digest/md5'

class Site < ActiveRecord::Base
  include CurrentObject
  include Liquify::Methods

  validates_presence_of :name, :domain, :theme_id
  validates_uniqueness_of :name, :domain
  validates_inclusion_of :production, :in => [true, false]
  validates_numericality_of :theme_id

  after_create :assign_key
  after_create :generate_homepage

  liquify_method :name, :homepage

  attr_accessible :name, :domain, :production, :theme_id

  has_many :pages, :dependent => :destroy
  has_many :assets, :dependent => :destroy

  belongs_to :homepage, :class_name => 'Page'
  belongs_to :theme

  def self.find_by_request(request, args={})
    domain = request.domain
    unless request.subdomain == 'www' || request.subdomain.empty?
      domain = "#{request.subdomain}.#{domain}"
    end

    conditions = { :domain => domain }
    conditions[:key] = args[:with_key] if args[:with_key]

    first(:conditions => conditions)
  end

  private
    def assign_key
      write_attribute :key, Digest::MD5.new(id).to_s
      self.save
    end

    def generate_homepage
      create_homepage(:title => 'Homepage', :site => self, :slug => '/')
      self.save
    end
end
