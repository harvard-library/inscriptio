class CreateReservableAssets < ActiveRecord::Migration
  def self.up
    create_table :reservable_assets do |t|
      t.references :floor
      t.references :reservable_asset_type
      t.string :name
      t.text :description
      t.string :location
      t.integer :min_reservation_time
      t.integer :max_reservation_time
      t.integer :max_concurrent_users
      t.integer :reservation_time_increment
      t.string :access_code
      t.string :photo
      t.text :notes
      t.integer :x1
      t.integer :y1
      t.integer :x2
      t.integer :y2
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
