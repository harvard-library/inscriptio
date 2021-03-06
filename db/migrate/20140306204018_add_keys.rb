class AddKeys < ActiveRecord::Migration
  def change
    add_foreign_key "bulletin_boards", "reservable_assets", name: "bulletin_boards_reservable_asset_id_fk"
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
    add_foreign_key "user_types", "libraries", name: "user_types_library_id_fk"
    add_foreign_key "user_types_users", "users", name: "user_types_users_user_id_fk"
    add_foreign_key "user_types_users", "user_types", name: "user_types_users_user_type_id_fk"
    add_foreign_key "users", "school_affiliations", name: "users_school_affiliation_id_fk"
  end
end
