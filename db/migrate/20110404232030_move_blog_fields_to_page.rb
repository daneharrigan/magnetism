class MoveBlogFieldsToPage < ActiveRecord::Migration
  def self.up
    add_column :pages, :excerpt, :text
    add_column :pages, :article, :text
    drop_table :blogs
  end

  def self.down
    remove_column :pages, :excerpt
    remove_column :pages, :article

    create_table :blogs do |t|
      t.integer :page_id
      t.integer :author_id
      t.text :excerpt
      t.text :article
    end
  end
end
