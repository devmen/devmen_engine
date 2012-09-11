# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20120911094714) do

  create_table "contact_us_entries", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "news", :force => true do |t|
    t.string   "name"
    t.date     "date"
    t.text     "text"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "category_id"
  end

  add_index "news", ["category_id"], :name => "index_news_on_category_id"

  create_table "news_categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "pages", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.text     "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "ancestry"
  end

  add_index "pages", ["ancestry"], :name => "index_pages_on_ancestry"
  add_index "pages", ["url"], :name => "index_pages_on_url", :unique => true

  create_table "realty", :force => true do |t|
    t.string   "name"
    t.integer  "price",       :default => 0, :null => false
    t.text     "address"
    t.text     "description"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "category_id"
  end

  add_index "realty", ["category_id"], :name => "index_realty_on_category_id"

  create_table "realty_categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "realty_photos", :force => true do |t|
    t.integer  "entry_id"
    t.string   "image"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "realty_photos", ["entry_id"], :name => "index_realty_photos_on_entry_id"

  create_table "review_entries", :force => true do |t|
    t.string   "name"
    t.text     "content"
    t.boolean  "visible",    :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "review_entries", ["visible"], :name => "index_review_entries_on_visible"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "roles_mask"
  end

end
