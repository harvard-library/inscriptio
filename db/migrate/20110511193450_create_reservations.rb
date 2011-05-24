class CreateReservations < ActiveRecord::Migration
  def self.up
    create_table :reservations do |t|
      t.references :reservable_asset
      t.references :user
      t.datetime :start_date
      t.datetime :end_date
      t.boolean :approved, :default => false
      t.timestamps
    end
    
    [:reservable_asset_id, :user_id].each do|col|
      add_index :reservations, col
    end
  end

  def self.down
    drop_table :reservations
  end
end
