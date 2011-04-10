require 'digest/md5'
require 'defender'

class Comment < ActiveRecord::Base
  include Liquify::Methods
  include Defender::Spammable

  validates_presence_of :author_name, :author_ip, :body

  belongs_to :page
  liquify_methods :author_name, :author_email, :body, :gravatar

  def gravatar
    hash_value = Digest::MD5.hexdigest(author_email.to_s)
    "http://gravatar.com/avatar/#{hash_value}"
  end
end
