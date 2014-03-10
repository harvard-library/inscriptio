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

ActiveRecord::Schema.define(:version => 20140307185100) do

  create_table "bulletin_boards", :force => true do |t|
    t.integer  "reservable_asset_id"
    t.integer  "post_lifetime"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "bulletin_boards", ["reservable_asset_id"], :name => "index_bulletin_boards_on_reservable_asset_id"

  create_table "call_numbers", :force => true do |t|
    t.integer  "subject_area_id",               :null => false
    t.string   "call_number",     :limit => 50, :null => false
    t.string   "long_name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "call_numbers", ["call_number"], :name => "index_call_numbers_on_call_number"
  add_index "call_numbers", ["subject_area_id"], :name => "index_call_numbers_on_subject_area_id"

  create_table "call_numbers_floors", :id => false, :force => true do |t|
    t.integer "call_number_id"
    t.integer "floor_id"
  end

  add_index "call_numbers_floors", ["call_number_id"], :name => "index_call_numbers_floors_on_call_number_id"
  add_index "call_numbers_floors", ["floor_id"], :name => "index_call_numbers_floors_on_floor_id"

  create_table "emails", :force => true do |t|
    t.string   "to"
    t.string   "bcc"
    t.string   "from"
    t.string   "reply_to"
    t.string   "subject"
    t.text     "body"
    t.date     "date_sent"
    t.boolean  "message_sent", :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "floors", :force => true do |t|
    t.integer  "library_id"
    t.string   "name",       :null => false
    t.integer  "position"
    t.string   "floor_map"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "floors", ["floor_map"], :name => "index_floors_on_floor_map"
  add_index "floors", ["library_id"], :name => "index_floors_on_library_id"
  add_index "floors", ["position"], :name => "index_floors_on_position"

  create_table "libraries", :force => true do |t|
    t.string   "name",         :null => false
    t.string   "url"
    t.string   "address_1",    :null => false
    t.string   "address_2"
    t.string   "city",         :null => false
    t.string   "state",        :null => false
    t.string   "zip",          :null => false
    t.string   "latitude"
    t.string   "longitude"
    t.text     "contact_info"
    t.text     "description"
    t.text     "tos"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "bcc"
    t.string   "from"
    t.datetime "deleted_at"
  end

  create_table "libraries_users_admin_permissions", :id => false, :force => true do |t|
    t.integer "user_id",    :null => false
    t.integer "library_id", :null => false
  end

  add_index "libraries_users_admin_permissions", ["library_id"], :name => "index_libraries_users_admin_permissions_on_library_id"
  add_index "libraries_users_admin_permissions", ["user_id"], :name => "index_libraries_users_admin_permissions_on_user_id"

  create_table "messages", :force => true do |t|
    t.string   "title",       :null => false
    t.text     "content",     :null => false
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "moderator_flags", :force => true do |t|
    t.integer  "post_id"
    t.integer  "user_id"
    t.string   "reason",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "moderator_flags", ["post_id"], :name => "index_moderator_flags_on_post_id"
  add_index "moderator_flags", ["reason"], :name => "index_moderator_flags_on_reason"
  add_index "moderator_flags", ["user_id"], :name => "index_moderator_flags_on_user_id"

  create_table "posts", :force => true do |t|
    t.integer  "bulletin_board_id"
    t.integer  "user_id"
    t.string   "message"
    t.string   "media"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts", ["bulletin_board_id"], :name => "index_posts_on_bulletin_board_id"
  add_index "posts", ["created_at"], :name => "index_posts_on_created_at"
  add_index "posts", ["user_id"], :name => "index_posts_on_user_id"

  create_table "reservable_asset_types", :force => true do |t|
    t.integer  "library_id"
    t.string   "name",                                         :null => false
    t.integer  "min_reservation_time"
    t.integer  "max_reservation_time"
    t.integer  "max_concurrent_users"
    t.boolean  "has_code"
    t.boolean  "require_moderation"
    t.text     "welcome_message"
    t.integer  "expiration_extension_time"
    t.boolean  "has_bulletin_board",        :default => false
    t.string   "photo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slots"
    t.datetime "deleted_at"
  end

  add_index "reservable_asset_types", ["library_id"], :name => "index_reservable_asset_types_on_library_id"
  add_index "reservable_asset_types", ["name"], :name => "index_reservable_asset_types_on_name"

  create_table "reservable_asset_types_user_types", :id => false, :force => true do |t|
    t.integer "reservable_asset_type_id"
    t.integer "user_type_id"
  end

  add_index "reservable_asset_types_user_types", ["reservable_asset_type_id"], :name => "reservable_asset_type_index"
  add_index "reservable_asset_types_user_types", ["user_type_id"], :name => "user_type_index"

  create_table "reservable_assets", :force => true do |t|
    t.integer  "floor_id"
    t.integer  "reservable_asset_type_id"
    t.string   "name"
    t.text     "description"
    t.string   "location"
    t.integer  "min_reservation_time"
    t.integer  "max_reservation_time"
    t.integer  "max_concurrent_users"
    t.string   "access_code"
    t.string   "photo"
    t.text     "notes"
    t.integer  "x1"
    t.integer  "y1"
    t.integer  "x2"
    t.integer  "y2"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slots"
    t.datetime "deleted_at"
  end

  add_index "reservable_assets", ["floor_id"], :name => "index_reservable_assets_on_floor_id"
  add_index "reservable_assets", ["reservable_asset_type_id"], :name => "index_reservable_assets_on_reservable_asset_type_id"

  create_table "reservation_notices", :force => true do |t|
    t.integer  "library_id"
    t.integer  "reservable_asset_type_id"
    t.integer  "status_id"
    t.string   "subject",                  :limit => 250
    t.text     "message"
    t.string   "reply_to"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "reservations", :force => true do |t|
    t.integer  "reservable_asset_id"
    t.integer  "user_id"
    t.integer  "status_id"
    t.date     "start_date"
    t.date     "end_date"
    t.boolean  "tos"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slot"
    t.datetime "deleted_at"
  end

  add_index "reservations", ["reservable_asset_id"], :name => "index_reservations_on_reservable_asset_id"
  add_index "reservations", ["user_id"], :name => "index_reservations_on_user_id"

  create_table "school_affiliations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subject_areas", :force => true do |t|
    t.string   "name",        :null => false
    t.string   "long_name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "library_id",  :null => false
    t.datetime "deleted_at"
  end

  add_index "subject_areas", ["name"], :name => "index_subject_areas_on_name"

  create_table "user_types", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "library_id", :null => false
    t.datetime "deleted_at"
  end

  add_index "user_types", ["name"], :name => "index_user_types_on_name"

  create_table "user_types_users", :id => false, :force => true do |t|
    t.integer "user_id",      :null => false
    t.integer "user_type_id", :null => false
  end

  add_index "user_types_users", ["user_id", "user_type_id"], :name => "index_user_types_users_on_user_id_and_user_type_id", :unique => true
  add_index "user_types_users", ["user_id"], :name => "index_user_types_users_on_user_id"
  add_index "user_types_users", ["user_type_id"], :name => "index_user_types_users_on_user_type_id"

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "",    :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "school_affiliation_id"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                                 :default => false
    t.datetime "deleted_at"
    t.datetime "reset_password_sent_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

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
