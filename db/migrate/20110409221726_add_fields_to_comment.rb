class AddFieldsToComment < ActiveRecord::Migration
  def self.up
    add_column :comments, :spam,         :boolean
    add_column :comments, :defensio_sig, :string
    add_column :comments, :spaminess,    :float
    add_column :comments, :author_ip,    :string
    add_column :comments, :author_url,   :string

    rename_column :comments, :message, :body
    rename_column :comments, :name,    :author_name
    rename_column :comments, :email,   :author_email
  end

  def self.down
    remove_column :comments, :spam,         :boolean
    remove_column :comments, :defensio_sig, :string
    remove_column :comments, :spaminess,    :float
    remove_column :comments, :author_ip,    :string
    remove_column :comments, :author_url,   :string

    rename_column :comments, :body,         :message
    rename_column :comments, :author_name,  :name
    rename_column :comments, :author_email, :email
  end
end
