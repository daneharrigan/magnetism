class CreateFields < ActiveRecord::Migration
  def self.up
    create_table :fields do |t|
      t.string :name
      t.integer :field_type_id
      t.integer :template_id
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :fields
  end
end
