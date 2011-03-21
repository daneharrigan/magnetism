class AddFieldNameToData < ActiveRecord::Migration
  def self.up
    remove_column :data, :field_id
    add_column :data, :field_name, :string
  end

  def self.down
    add_column :data, :field_id, :integer
    remove_column :data, :field_name
  end
end
