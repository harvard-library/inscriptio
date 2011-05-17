class CreateReservableAssetTypes < ActiveRecord::Migration
  def self.up
    create_table :reservable_asset_types do |t|
      t.references :library
      t.string :name, :null => false
      t.string :min_reservation_time
      t.string :max_reservation_time
      t.integer :max_concurrent_users
      t.string :reservation_time_increment
      t.boolean :has_code
      t.text :welcome_message
      t.string :expiration_extension_time
      t.boolean :requires_moderation, :default => true
      t.text :moderation_held_message
      t.boolean :has_bulletin_board, :default => false
      t.string :photo
      t.timestamps
    end
    
    [:library_id, :name].each do|col|
      add_index :reservable_asset_types, col
    end
    
    create_table(:reservable_asset_types_user_types, :id => false) do|t|
      t.references :reservable_asset_type
      t.references :user_type
    end
    
    add_index :reservable_asset_types_user_types, :reservable_asset_type_id, :name => :reservable_asset_type_index
    add_index :reservable_asset_types_user_types, :user_type_id, :name => :user_type_index
  end

  def self.down
    drop_table :reservable_asset_types
    drop_table :reservable_asset_types_user_types
  end
end
