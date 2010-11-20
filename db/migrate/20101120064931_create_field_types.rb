class CreateFieldTypes < ActiveRecord::Migration
  def self.up
    create_table :field_types do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :field_types
  end
end
