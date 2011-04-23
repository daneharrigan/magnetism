class CreateRedirects < ActiveRecord::Migration
  def self.up
    create_table :redirects do |t|
      t.string :url
      t.integer :page_id
      t.integer :site_id
    end
  end

  def self.down
    drop_table :redirects
  end
end
