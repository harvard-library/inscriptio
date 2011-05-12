class CreateReservableAssets < ActiveRecord::Migration
  def self.up
    create_table :reservable_assets do |t|
      t.references :floor
      t.references :reservable_asset_type
      t.string :location
      t.string :min_reservation_time
      t.string :max_reservation_time
      t.integer :max_concurrent_users
      t.string :reservation_time_increment
      t.text :general_info
      t.string :photo
      t.timestamps
    end
    
    [:floor_id, :reservable_asset_type_id].each do|col|
      add_index :reservable_assets, col
    end
  end

  def self.down
    drop_table :reservable_assets
  end
end
