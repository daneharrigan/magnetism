class AddTimestamps < ActiveRecord::Migration
  def self.up
    add_column :archives, :created_at, :datetime
    add_column :archives, :updated_at, :datetime

    add_column :comments, :created_at, :datetime
    add_column :comments, :updated_at, :datetime
  end

  def self.down
    remove_column :archives, :created_at, :datetime
    remove_column :archives, :updated_at, :datetime

    remove_column :comments, :created_at, :datetime
    remove_column :comments, :updated_at, :datetime
  end
end
