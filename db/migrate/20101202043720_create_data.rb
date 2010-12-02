class CreateData < ActiveRecord::Migration
  def self.up
    create_table :data do |t|
      t.integer :field_id
      t.integer :page_id
      t.string :entry_type
      t.integer :entry_id

      t.timestamps
    end
  end

  def self.down
    drop_table :data
  end
end
