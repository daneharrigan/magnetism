class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string :title
      t.string :slug
      t.integer :site_id
      t.integer :parent_id
      t.integer :template_id
      t.integer :template_set_id
      t.datetime :publish_at
      t.boolean :blog_section, :default => false
      t.string :uri_format
      t.boolean :publish, :default => false
      t.datetime :cached_at

      t.timestamps
    end

    add_index :pages, :slug
  end

  def self.down
    drop_table :pages
  end
end
