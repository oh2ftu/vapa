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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140913194138) do

  create_table "categories", force: true do |t|
    t.string   "acronym"
    t.text     "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", force: true do |t|
    t.string   "tagid"
    t.string   "rfid"
    t.string   "item_class"
    t.string   "item_subclass"
    t.integer  "weight"
    t.text     "description"
    t.date     "purchased_at_date"
    t.text     "purchased_at"
    t.date     "warranty_until"
    t.date     "lifetime_until"
    t.string   "serial"
    t.string   "sku"
    t.integer  "price"
    t.string   "owner"
    t.date     "last_seen"
    t.integer  "service_interval"
    t.boolean  "lup"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ancestry"
    t.text     "memo"
    t.integer  "category_id"
    t.integer  "sub_category_id"
    t.string   "size"
  end

  add_index "items", ["category_id"], name: "index_items_on_category_id"
  add_index "items", ["sub_category_id"], name: "index_items_on_sub_category_id"

  create_table "sub_categories", force: true do |t|
    t.string   "acronym"
    t.text     "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id"
  end

  add_index "sub_categories", ["category_id"], name: "index_sub_categories_on_category_id"

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
