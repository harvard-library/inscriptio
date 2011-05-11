class CreateReservableAssetTypes < ActiveRecord::Migration
  def self.up
    create_table :reservable_asset_types do |t|
      t.references :library
      t.string :name, :null => false
      t.string :min_reservation_time
      t.string :max_reservation_time
      t.integer :max_concurrent_users
      t.string :reservation_time_increment
      t.boolean :code
      t.text :welcome_message
      t.string :expiration_extension_time
      t.timestamps
    end
    
    [:library_id, :name].each do|col|
      add_index :reservable_asset_types, col
    end
  end

  def self.down
    drop_table :reservable_asset_types
  end
end
