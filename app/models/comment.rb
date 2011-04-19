require 'digest/md5'
require 'defender'

class Comment < ActiveRecord::Base
  include Liquify::Methods
  include ActionView::Helpers::SanitizeHelper

  if Magnetism.defensio_key
    include Defender::Spammable
    configure_defender :api_key => Magnetism.defensio_key
  end

  belongs_to :page

  validates_presence_of :author_ip, :body
  attr_accessible :author_name, :author_email, :author_url, :author_ip, :body

  liquify_methods :author_name, :author_email, :author_url, :body, :gravatar, :id, :publish_at, :by_user?

  scope :excluding_spam, lambda { where(['spam = ? OR spam IS NULL', false]) }

  def gravatar
    hash_value = Digest::MD5.hexdigest(author_email.to_s)
    "http://gravatar.com/avatar/#{hash_value}"
  end

  def publish_at
    created_at
  end

  def by_user?
    user_id?
  end

  def body
    value = read_attribute :body
    return if value.nil?

    value = RedCloth.new(value).to_html
    sanitize(value, :tags => %w(p a strong em blockquote pre code), :attributes => 'href')
  end
end
