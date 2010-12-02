class Datum < ActiveRecord::Base
  belongs_to :field
  belongs_to :page
  belongs_to :entry, :polymorphic => true
end
