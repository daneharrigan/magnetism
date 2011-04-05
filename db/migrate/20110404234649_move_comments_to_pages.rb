class MoveCommentsToPages < ActiveRecord::Migration
  def self.up
    rename_column :comments, :blog_id, :page_id
  end

  def self.down
    rename_column :comments, :page_id, :blog_id
  end
end
