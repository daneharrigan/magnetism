class Datum < ActiveRecord::Base
  belongs_to :page
  belongs_to :entry, :polymorphic => true
end
