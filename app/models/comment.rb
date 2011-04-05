class Comment < ActiveRecord::Base
  belongs_to :page
  validates_presence_of :name, :email, :message
end
