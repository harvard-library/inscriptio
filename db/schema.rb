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

ActiveRecord::Schema.define(:version => 20110504203806) do

  create_table "call_numbers", :force => true do |t|
    t.integer  "subject_area_id"
    t.string   "call_number",     :limit => 50, :null => false
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

  create_table "subject_areas", :force => true do |t|
    t.string   "name",        :null => false
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subject_areas", ["name"], :name => "index_subject_areas_on_name"

  create_table "subject_areas_floors", :id => false, :force => true do |t|
    t.integer "subject_area_id"
    t.integer "floor_id"
  end

  add_index "subject_areas_floors", ["floor_id"], :name => "index_subject_areas_floors_on_floor_id"
  add_index "subject_areas_floors", ["subject_area_id"], :name => "index_subject_areas_floors_on_subject_area_id"

end
