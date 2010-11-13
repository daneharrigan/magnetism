class CreateSites < ActiveRecord::Migration
  def self.up
    create_table :sites do |t|
      t.string :name
      t.string :domain
      t.boolean :production, :default => false
      t.integer :theme_id
      t.integer :homepage_id

      t.timestamps
    end
  end

  def self.down
    drop_table :sites
  end
end
