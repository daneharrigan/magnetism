class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.integer :blog_id
      t.string :name
      t.string :email
      t.text :message
    end
  end
end
