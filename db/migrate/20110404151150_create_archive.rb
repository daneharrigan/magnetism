class CreateArchive < ActiveRecord::Migration
  def self.up
    create_table :archives do |t|
      t.integer :blog_section_id
      t.date :publish_range
      t.integer :article_count
    end
  end

  def self.down
    drop_table :archives
  end
end
