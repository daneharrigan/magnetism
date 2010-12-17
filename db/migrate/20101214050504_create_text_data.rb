class CreateTextData < ActiveRecord::Migration
  def self.up
    create_table :text_data do |t|
      t.text :value

      t.timestamps
    end
  end

  def self.down
    drop_table :text_data
  end
end
