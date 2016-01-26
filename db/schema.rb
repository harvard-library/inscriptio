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

ActiveRecord::Schema.define(version: 20140307185100) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bulletin_boards", force: :cascade do |t|
    t.integer  "reservable_asset_id"
    t.integer  "post_lifetime"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "bulletin_boards", ["reservable_asset_id"], name: "index_bulletin_boards_on_reservable_asset_id", using: :btree

  create_table "call_numbers", force: :cascade do |t|
    t.integer  "subject_area_id",             null: false
    t.string   "call_number",     limit: 50,  null: false
    t.string   "long_name",       limit: 255
    t.string   "description",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "call_numbers", ["call_number"], name: "index_call_numbers_on_call_number", using: :btree
  add_index "call_numbers", ["subject_area_id"], name: "index_call_numbers_on_subject_area_id", using: :btree

  create_table "call_numbers_floors", id: false, force: :cascade do |t|
    t.integer "call_number_id"
    t.integer "floor_id"
  end

  add_index "call_numbers_floors", ["call_number_id"], name: "index_call_numbers_floors_on_call_number_id", using: :btree
  add_index "call_numbers_floors", ["floor_id"], name: "index_call_numbers_floors_on_floor_id", using: :btree

  create_table "emails", force: :cascade do |t|
    t.string   "to",           limit: 255
    t.string   "bcc",          limit: 255
    t.string   "from",         limit: 255
    t.string   "reply_to",     limit: 255
    t.string   "subject",      limit: 255
    t.text     "body"
    t.date     "date_sent"
    t.boolean  "message_sent",             default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "floors", force: :cascade do |t|
    t.integer  "library_id"
    t.string   "name",       limit: 255, null: false
    t.integer  "position"
    t.string   "floor_map",  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "floors", ["floor_map"], name: "index_floors_on_floor_map", using: :btree
  add_index "floors", ["library_id"], name: "index_floors_on_library_id", using: :btree
  add_index "floors", ["position"], name: "index_floors_on_position", using: :btree

  create_table "libraries", force: :cascade do |t|
    t.string   "name",         limit: 255, null: false
    t.string   "url",          limit: 255
    t.string   "address_1",    limit: 255, null: false
    t.string   "address_2",    limit: 255
    t.string   "city",         limit: 255, null: false
    t.string   "state",        limit: 255, null: false
    t.string   "zip",          limit: 255, null: false
    t.string   "latitude",     limit: 255
    t.string   "longitude",    limit: 255
    t.text     "contact_info"
    t.text     "description"
    t.text     "tos"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "bcc",          limit: 255
    t.string   "from",         limit: 255
    t.datetime "deleted_at"
  end

  create_table "libraries_users_admin_permissions", id: false, force: :cascade do |t|
    t.integer "user_id",    null: false
    t.integer "library_id", null: false
  end

  add_index "libraries_users_admin_permissions", ["library_id"], name: "index_libraries_users_admin_permissions_on_library_id", using: :btree
  add_index "libraries_users_admin_permissions", ["user_id"], name: "index_libraries_users_admin_permissions_on_user_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.string   "title",       limit: 255, null: false
    t.text     "content",                 null: false
    t.string   "description", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "moderator_flags", force: :cascade do |t|
    t.integer  "post_id"
    t.integer  "user_id"
    t.string   "reason",     limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "moderator_flags", ["post_id"], name: "index_moderator_flags_on_post_id", using: :btree
  add_index "moderator_flags", ["reason"], name: "index_moderator_flags_on_reason", using: :btree
  add_index "moderator_flags", ["user_id"], name: "index_moderator_flags_on_user_id", using: :btree

  create_table "posts", force: :cascade do |t|
    t.integer  "bulletin_board_id"
    t.integer  "user_id"
    t.string   "message",           limit: 255
    t.string   "media",             limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts", ["bulletin_board_id"], name: "index_posts_on_bulletin_board_id", using: :btree
  add_index "posts", ["created_at"], name: "index_posts_on_created_at", using: :btree
  add_index "posts", ["user_id"], name: "index_posts_on_user_id", using: :btree

  create_table "reservable_asset_types", force: :cascade do |t|
    t.integer  "library_id"
    t.string   "name",                      limit: 255,                 null: false
    t.integer  "min_reservation_time"
    t.integer  "max_reservation_time"
    t.integer  "max_concurrent_users"
    t.boolean  "has_code"
    t.boolean  "require_moderation"
    t.text     "welcome_message"
    t.integer  "expiration_extension_time"
    t.boolean  "has_bulletin_board",                    default: false
    t.string   "photo",                     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slots",                     limit: 255
    t.datetime "deleted_at"
  end

  add_index "reservable_asset_types", ["library_id"], name: "index_reservable_asset_types_on_library_id", using: :btree
  add_index "reservable_asset_types", ["name"], name: "index_reservable_asset_types_on_name", using: :btree

  create_table "reservable_asset_types_user_types", id: false, force: :cascade do |t|
    t.integer "reservable_asset_type_id"
    t.integer "user_type_id"
  end

  add_index "reservable_asset_types_user_types", ["reservable_asset_type_id"], name: "reservable_asset_type_index", using: :btree
  add_index "reservable_asset_types_user_types", ["user_type_id"], name: "user_type_index", using: :btree

  create_table "reservable_assets", force: :cascade do |t|
    t.integer  "floor_id"
    t.integer  "reservable_asset_type_id"
    t.string   "name",                     limit: 255
    t.text     "description"
    t.string   "location",                 limit: 255
    t.integer  "min_reservation_time"
    t.integer  "max_reservation_time"
    t.integer  "max_concurrent_users"
    t.string   "access_code",              limit: 255
    t.string   "photo",                    limit: 255
    t.text     "notes"
    t.integer  "x1"
    t.integer  "y1"
    t.integer  "x2"
    t.integer  "y2"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slots",                    limit: 255
    t.datetime "deleted_at"
  end

  add_index "reservable_assets", ["floor_id"], name: "index_reservable_assets_on_floor_id", using: :btree
  add_index "reservable_assets", ["reservable_asset_type_id"], name: "index_reservable_assets_on_reservable_asset_type_id", using: :btree

  create_table "reservation_notices", force: :cascade do |t|
    t.integer  "library_id"
    t.integer  "reservable_asset_type_id"
    t.integer  "status_id"
    t.string   "subject",                  limit: 250
    t.text     "message"
    t.string   "reply_to",                 limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "reservations", force: :cascade do |t|
    t.integer  "reservable_asset_id"
    t.integer  "user_id"
    t.integer  "status_id"
    t.date     "start_date"
    t.date     "end_date"
    t.boolean  "tos"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slot",                limit: 255
    t.datetime "deleted_at"
  end

  add_index "reservations", ["reservable_asset_id"], name: "index_reservations_on_reservable_asset_id", using: :btree
  add_index "reservations", ["user_id"], name: "index_reservations_on_user_id", using: :btree

  create_table "school_affiliations", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subject_areas", force: :cascade do |t|
    t.string   "name",        limit: 255, null: false
    t.string   "long_name",   limit: 255
    t.string   "description", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "library_id",              null: false
    t.datetime "deleted_at"
  end

  add_index "subject_areas", ["name"], name: "index_subject_areas_on_name", using: :btree

  create_table "user_types", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "library_id",             null: false
    t.datetime "deleted_at"
  end

  add_index "user_types", ["name"], name: "index_user_types_on_name", using: :btree

  create_table "user_types_users", id: false, force: :cascade do |t|
    t.integer "user_id",      null: false
    t.integer "user_type_id", null: false
  end

  add_index "user_types_users", ["user_id", "user_type_id"], name: "index_user_types_users_on_user_id_and_user_type_id", unique: true, using: :btree
  add_index "user_types_users", ["user_id"], name: "index_user_types_users_on_user_id", using: :btree
  add_index "user_types_users", ["user_type_id"], name: "index_user_types_users_on_user_type_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",    null: false
    t.string   "encrypted_password",     limit: 128, default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.integer  "school_affiliation_id"
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                              default: false
    t.datetime "deleted_at"
    t.datetime "reset_password_sent_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "bulletin_boards", "reservable_assets", name: "bulletin_boards_reservable_asset_id_fk"
  add_foreign_key "call_numbers", "subject_areas", name: "fk_call_numbers_subject_area"
  add_foreign_key "call_numbers_floors", "call_numbers", name: "call_numbers_floors_call_number_id_fk"
  add_foreign_key "call_numbers_floors", "floors", name: "call_numbers_floors_floor_id_fk"
  add_foreign_key "floors", "libraries", name: "floors_library_id_fk"
  add_foreign_key "moderator_flags", "posts", name: "moderator_flags_post_id_fk"
  add_foreign_key "moderator_flags", "users", name: "moderator_flags_user_id_fk"
  add_foreign_key "posts", "bulletin_boards", name: "posts_bulletin_board_id_fk"
  add_foreign_key "posts", "users", name: "posts_user_id_fk"
  add_foreign_key "reservable_asset_types", "libraries", name: "reservable_asset_types_library_id_fk"
  add_foreign_key "reservable_asset_types_user_types", "reservable_asset_types", name: "reservable_asset_types_user_types_reservable_asset_type_id_fk"
  add_foreign_key "reservable_asset_types_user_types", "user_types", name: "reservable_asset_types_user_types_user_type_id_fk"
  add_foreign_key "reservable_assets", "floors", name: "reservable_assets_floor_id_fk"
  add_foreign_key "reservable_assets", "reservable_asset_types", name: "reservable_assets_reservable_asset_type_id_fk"
  add_foreign_key "reservation_notices", "libraries", name: "reservation_notices_library_id_fk"
  add_foreign_key "reservation_notices", "reservable_asset_types", name: "reservation_notices_reservable_asset_type_id_fk"
  add_foreign_key "reservations", "reservable_assets", name: "reservations_reservable_asset_id_fk"
  add_foreign_key "reservations", "users", name: "reservations_user_id_fk"
  add_foreign_key "subject_areas", "libraries", name: "fk_subject_areas_libraries"
  add_foreign_key "user_types", "libraries", name: "user_types_library_id_fk"
  add_foreign_key "user_types_users", "user_types", name: "user_types_users_user_type_id_fk"
  add_foreign_key "user_types_users", "users", name: "user_types_users_user_id_fk"
  add_foreign_key "users", "school_affiliations", name: "users_school_affiliation_id_fk"
end
