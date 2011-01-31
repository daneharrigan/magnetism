class CreateBlog < ActiveRecord::Migration
  def self.up
    create_table :blogs do |t|
      t.integer :page_id
      t.integer :author_id
      t.text :excerpt
      t.text :article
    end
  end

  def self.down
    drop_table :blog
  end
end
