class Blog < ActiveRecord::Base
  include Liquify::Methods

  belongs_to :page
  has_many :comments

  liquify_methods :article, :excerpt
end
