require 'digest/md5'
require 'defender'

class Comment < ActiveRecord::Base
  include Liquify::Methods

  if Magnetism.defensio_key
    include Defender::Spammable
    configure_defender :api_key => Magnetism.defensio_key
  end

  belongs_to :page

  validates_presence_of :author_ip, :body
  attr_accessible :author_name, :author_email, :author_url, :author_ip, :body

  liquify_methods :author_name, :author_email, :author_url, :body, :gravatar

  scope :excluding_spam, lambda { where('spam = false OR spam IN NULL') }

  def gravatar
    hash_value = Digest::MD5.hexdigest(author_email.to_s)
    "http://gravatar.com/avatar/#{hash_value}"
  end
end
