class AddSlotsReservableAsset < ActiveRecord::Migration
  def self.up
    add_column :reservable_assets, :slots, :string
  end

  def self.down
    add_column :slots
  end
end
