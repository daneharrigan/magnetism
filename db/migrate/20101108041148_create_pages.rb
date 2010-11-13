class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string :title
      t.string :slug
      t.integer :site_id
      t.integer :parent_id
      t.datetime :publish_at
      # t.integer :template_id
      # t.boolean :blog, :default => false
      # t.string :uri_matcher
      # t.boolean :active, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :pages
  end
end
