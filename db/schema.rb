# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110201004404) do

  create_table "assets", :force => true do |t|
    t.integer  "site_id"
    t.string   "description"
    t.string   "file"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blogs", :force => true do |t|
    t.integer "page_id"
    t.integer "author_id"
    t.text    "excerpt"
    t.text    "article"
  end

  create_table "data", :force => true do |t|
    t.integer  "field_id"
    t.integer  "page_id"
    t.string   "entry_type"
    t.integer  "entry_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "field_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fields", :force => true do |t|
    t.string   "name"
    t.integer  "field_type_id"
    t.integer  "template_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.string   "slug"
    t.integer  "site_id"
    t.integer  "parent_id"
    t.integer  "template_id"
    t.datetime "publish_at"
    t.boolean  "blog_section", :default => false
    t.string   "uri_format"
    t.boolean  "publish",      :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pages", ["slug"], :name => "index_pages_on_slug"

  create_table "sites", :force => true do |t|
    t.string   "name"
    t.string   "domain"
    t.boolean  "production",  :default => false
    t.integer  "theme_id"
    t.integer  "homepage_id"
    t.string   "key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sites", ["key"], :name => "index_sites_on_key"

  create_table "string_data", :force => true do |t|
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "template_sets", :force => true do |t|
    t.string  "name"
    t.integer "theme_id"
  end

  create_table "template_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "templates", :force => true do |t|
    t.string   "name"
    t.integer  "template_type_id"
    t.integer  "template_set_id"
    t.integer  "theme_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "text_data", :force => true do |t|
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "themes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "name"
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["login"], :name => "index_users_on_login", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
