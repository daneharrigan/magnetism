class AddCommentAttributes < ActiveRecord::Migration
  def self.up
    add_column :comments, :user_id, :integer
    add_column :pages, :close_comments, :boolean
    add_column :pages, :close_comments_at, :date
  end

  def self.down
    remove_column :comments, :user_id, :integer
    remove_column :pages, :close_comments, :boolean
    remove_column :pages, :close_comments_at, :date
  end
end
