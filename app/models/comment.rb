require 'digest/md5'

class Comment < ActiveRecord::Base
  include Liquify::Methods

  belongs_to :page
  validates_presence_of :name, :message
  liquify_methods :name, :email, :message, :gravatar

  def gravatar
    hash_value = Digest::MD5.hexdigest(email.to_s)
    "http://gravatar.com/avatar/#{hash_value}"
  end
end
