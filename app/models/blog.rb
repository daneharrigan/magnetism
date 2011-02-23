class Blog < ActiveRecord::Base
  belongs_to :page
  has_many :comments
end
