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

ActiveRecord::Schema.define(version: 20141109121856) do

  create_table "addresses", force: true do |t|
    t.string   "line1"
    t.string   "line2"
    t.string   "city"
    t.string   "zip"
    t.integer  "addressable_id"
    t.string   "addressable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "addresses", ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable_type_and_addressable_id", unique: true, using: :btree

  create_table "categories", force: true do |t|
    t.string   "acronym"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "checkout_items", force: true do |t|
    t.integer  "item_id"
    t.integer  "checkout_id"
    t.boolean  "returned",    default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "checkout_items", ["checkout_id"], name: "index_checkout_items_on_checkout_id", using: :btree
  add_index "checkout_items", ["item_id"], name: "index_checkout_items_on_item_id", using: :btree

  create_table "checkouts", force: true do |t|
    t.integer  "user_id"
    t.datetime "checkout"
    t.datetime "return"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "department_id"
  end

  add_index "checkouts", ["department_id"], name: "index_checkouts_on_department_id", using: :btree
  add_index "checkouts", ["user_id"], name: "index_checkouts_on_user_id", using: :btree

  create_table "cloths", force: true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "size"
    t.integer  "amount"
    t.date     "issued"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "department_id"
  end

  add_index "cloths", ["department_id"], name: "index_cloths_on_department_id", using: :btree
  add_index "cloths", ["user_id"], name: "index_cloths_on_user_id", using: :btree

  create_table "comments", force: true do |t|
    t.string   "commenter"
    t.text     "body"
    t.integer  "price",         default: 0,     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "service",       default: false, null: false
    t.boolean  "inspection",    default: false, null: false
    t.integer  "vendor_id"
    t.integer  "department_id"
    t.integer  "user_id"
  end

  add_index "comments", ["department_id"], name: "index_comments_on_department_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree
  add_index "comments", ["vendor_id"], name: "index_comments_on_vendor_id", using: :btree

  create_table "comments_items", id: false, force: true do |t|
    t.integer "comment_id", null: false
    t.integer "item_id",    null: false
  end

  create_table "comments_service_events", id: false, force: true do |t|
    t.integer "comment_id",       null: false
    t.integer "service_event_id", null: false
  end

  create_table "departments", force: true do |t|
    t.string   "name"
    t.string   "station"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "department_id"
  end

  add_index "groups", ["department_id"], name: "index_groups_on_department_id", using: :btree

  create_table "groups_users", id: false, force: true do |t|
    t.integer "group_id", null: false
    t.integer "user_id",  null: false
  end

  create_table "identifiers", force: true do |t|
    t.string   "barcode"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "department_id"
  end

  add_index "identifiers", ["department_id"], name: "index_identifiers_on_department_id", using: :btree

  create_table "identifiers_items", id: false, force: true do |t|
    t.integer "identifier_id", null: false
    t.integer "item_id",       null: false
  end

  create_table "items", force: true do |t|
    t.string   "tagid",                                                               null: false
    t.string   "rfid"
    t.decimal  "weight",              precision: 10, scale: 2
    t.string   "description"
    t.date     "purchased_at_date"
    t.string   "serial"
    t.integer  "price",                                        default: 0,            null: false
    t.date     "last_seen",                                    default: '2014-10-18', null: false
    t.integer  "service_interval",                             default: 0,            null: false
    t.boolean  "lup",                                          default: false,        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ancestry"
    t.text     "memo"
    t.integer  "category_id"
    t.integer  "sub_category_id"
    t.string   "size"
    t.string   "make"
    t.string   "model"
    t.boolean  "tagged",                                       default: false,        null: false
    t.integer  "vendor_id"
    t.integer  "status_id"
    t.integer  "life_time",                                    default: 0,            null: false
    t.integer  "warranty_time",                                default: 0,            null: false
    t.integer  "unit_id"
    t.integer  "inspection_interval",                          default: 0,            null: false
    t.integer  "owner_id"
    t.date     "into_use"
    t.boolean  "lup_inc",                                      default: false,        null: false
    t.integer  "department_id"
    t.integer  "user_id"
    t.boolean  "terminate_at_eol",                             default: false,        null: false
  end

  add_index "items", ["category_id"], name: "index_items_on_category_id", using: :btree
  add_index "items", ["department_id"], name: "index_items_on_department_id", using: :btree
  add_index "items", ["owner_id"], name: "index_items_on_owner_id", using: :btree
  add_index "items", ["status_id"], name: "index_items_on_status_id", using: :btree
  add_index "items", ["sub_category_id"], name: "index_items_on_sub_category_id", using: :btree
  add_index "items", ["unit_id"], name: "index_items_on_unit_id", using: :btree
  add_index "items", ["user_id"], name: "index_items_on_user_id", using: :btree
  add_index "items", ["vendor_id"], name: "index_items_on_vendor_id", using: :btree

  create_table "owners", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "department_id"
  end

  add_index "owners", ["department_id"], name: "index_owners_on_department_id", using: :btree

  create_table "roles", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", id: false, force: true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "service_events", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.boolean  "show",       default: false, null: false
  end

  create_table "statuses", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sub_categories", force: true do |t|
    t.string   "acronym"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id"
  end

  add_index "sub_categories", ["category_id"], name: "index_sub_categories_on_category_id", using: :btree

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: true do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "unit_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "acronym"
  end

  create_table "units", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "department_id"
    t.integer  "unit_type_id"
  end

  add_index "units", ["department_id"], name: "index_units_on_department_id", using: :btree
  add_index "units", ["unit_type_id"], name: "index_units_on_unit_type_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "firstname"
    t.string   "lastname"
    t.integer  "department_id"
    t.boolean  "paid",                   default: false
    t.boolean  "superuser",              default: false
    t.string   "phone"
    t.string   "jacket_size"
    t.string   "trouser_size"
    t.string   "boot_size"
    t.string   "vacancy"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["department_id"], name: "index_users_on_department_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_roles", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  create_table "vendors", force: true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "city"
    t.string   "contact"
    t.string   "phone"
    t.string   "email"
    t.text     "notes"
    t.boolean  "billing",    default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "versions", force: true do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
    t.string   "ip"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

end
