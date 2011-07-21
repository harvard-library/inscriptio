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

ActiveRecord::Schema.define(:version => 20110706182123) do

  create_table "bulletin_boards", :force => true do |t|
    t.integer  "reservable_asset_id"
    t.integer  "post_lifetime"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bulletin_boards", ["reservable_asset_id"], :name => "index_bulletin_boards_on_reservable_asset_id"

  create_table "call_numbers", :force => true do |t|
    t.integer  "subject_area_id"
    t.string   "call_number",     :limit => 50, :null => false
    t.string   "long_name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "call_numbers", ["call_number"], :name => "index_call_numbers_on_call_number"
  add_index "call_numbers", ["subject_area_id"], :name => "index_call_numbers_on_subject_area_id"

  create_table "call_numbers_floors", :id => false, :force => true do |t|
    t.integer "call_number_id"
    t.integer "floor_id"
  end

  add_index "call_numbers_floors", ["call_number_id"], :name => "index_call_numbers_floors_on_call_number_id"
  add_index "call_numbers_floors", ["floor_id"], :name => "index_call_numbers_floors_on_floor_id"

  create_table "floors", :force => true do |t|
    t.integer  "library_id"
    t.string   "name",       :null => false
    t.integer  "position"
    t.string   "floor_map"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "floors", ["floor_map"], :name => "index_floors_on_floor_map"
  add_index "floors", ["library_id"], :name => "index_floors_on_library_id"
  add_index "floors", ["position"], :name => "index_floors_on_position"

  create_table "floors_subject_areas", :id => false, :force => true do |t|
    t.integer "subject_area_id"
    t.integer "floor_id"
  end

  add_index "floors_subject_areas", ["floor_id"], :name => "index_floors_subject_areas_on_floor_id"
  add_index "floors_subject_areas", ["subject_area_id"], :name => "index_floors_subject_areas_on_subject_area_id"

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
    t.boolean  "public",            :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts", ["bulletin_board_id"], :name => "index_posts_on_bulletin_board_id"
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
  end

  create_table "reservations", :force => true do |t|
    t.integer  "reservable_asset_id"
    t.integer  "user_id"
    t.integer  "status_id"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reservations", ["reservable_asset_id"], :name => "index_reservations_on_reservable_asset_id"
  add_index "reservations", ["user_id"], :name => "index_reservations_on_user_id"

  create_table "statuses", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subject_areas", :force => true do |t|
    t.string   "name",        :null => false
    t.string   "long_name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subject_areas", ["name"], :name => "index_subject_areas_on_name"

  create_table "user_types", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_types", ["name"], :name => "index_user_types_on_name"

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "",    :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "user_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                               :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
