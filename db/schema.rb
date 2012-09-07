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

ActiveRecord::Schema.define(:version => 20120906092324) do

  create_table "carts", :force => true do |t|
    t.integer  "product_counter"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "contact_us_entries", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "friendly_id_slugs", :force => true do |t|
    t.string   "slug",                         :null => false
    t.integer  "sluggable_id",                 :null => false
    t.string   "sluggable_type", :limit => 40
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type"], :name => "index_friendly_id_slugs_on_slug_and_sluggable_type", :unique => true
  add_index "friendly_id_slugs", ["sluggable_id"], :name => "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], :name => "index_friendly_id_slugs_on_sluggable_type"

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

  create_table "orders", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.text     "address"
    t.string   "num"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "pages", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.text     "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "pages", ["url"], :name => "index_pages_on_url", :unique => true

  create_table "product_categories", :force => true do |t|
    t.integer  "parent_id"
    t.string   "name"
    t.text     "description"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "product_categories", ["depth"], :name => "index_product_categories_on_depth"
  add_index "product_categories", ["lft"], :name => "index_product_categories_on_lft"
  add_index "product_categories", ["parent_id"], :name => "index_product_categories_on_parent_id"
  add_index "product_categories", ["rgt"], :name => "index_product_categories_on_rgt"

  create_table "product_items", :force => true do |t|
    t.integer  "quantity"
    t.integer  "product_id"
    t.integer  "cart_id"
    t.integer  "order_id"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.decimal  "price",      :precision => 10, :scale => 2
    t.decimal  "amount",     :precision => 10, :scale => 2
  end

  add_index "product_items", ["cart_id"], :name => "index_product_items_on_cart_id"
  add_index "product_items", ["order_id"], :name => "index_product_items_on_order_id"
  add_index "product_items", ["product_id"], :name => "index_product_items_on_product_id"

  create_table "product_pictures", :force => true do |t|
    t.string   "image"
    t.integer  "product_id"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "product_pictures", ["product_id"], :name => "index_product_pictures_on_product_id"

  create_table "products", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "sku"
    t.decimal  "price",       :precision => 10, :scale => 2
    t.decimal  "old_price",   :precision => 10, :scale => 2
    t.integer  "in_stock"
    t.integer  "category_id"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.string   "slug"
  end

  add_index "products", ["category_id"], :name => "index_shop_products_on_category_id"
  add_index "products", ["slug"], :name => "index_products_on_slug"

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
