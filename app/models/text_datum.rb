class TextDatum < ActiveRecord::Base
  has_many :data, :as => :entry
end
