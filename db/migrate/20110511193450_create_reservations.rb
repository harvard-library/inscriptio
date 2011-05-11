class CreateReservations < ActiveRecord::Migration
  def self.up
    create_table :reservations do |t|
      t.references :reservable_asset
      t.references :user
      t.string :code, :null => false
      t.datetime :start_date
      t.datetime :end_date
      t.boolean :approved
      t.timestamps
    end
    
    [:reservable_asset_id, :user_id, :code].each do|col|
      add_index :reservations, col
    end
  end

  def self.down
    drop_table :reservations
  end
end
