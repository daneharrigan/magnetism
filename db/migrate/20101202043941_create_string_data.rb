class CreateStringData < ActiveRecord::Migration
  def self.up
    create_table :string_data do |t|
      t.string :value

      t.timestamps
    end
  end

  def self.down
    drop_table :string_data
  end
end
