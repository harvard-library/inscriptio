class AddSlotsReservableAsset < ActiveRecord::Migration
  def self.up
    add_column :reservable_assets, :slots, :string
  end

  def self.down
    remove_column :reservable_assets, :slots
  end
end
