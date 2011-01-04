class CreateAssets < ActiveRecord::Migration
  def self.up
    create_table :assets do |t|
      t.integer :site_id
      t.string :description
      t.string :file

      t.timestamps
    end
  end

  def self.down
    drop_table :assets
  end
end
