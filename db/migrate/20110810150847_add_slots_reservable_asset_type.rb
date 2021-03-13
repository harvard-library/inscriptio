class AddSlotsReservableAssetType < ActiveRecord::Migration[4.2]
  def self.up
    add_column :reservable_asset_types, :slots, :string
  end

  def self.down
    remove_column :reservable_asset_types, :slots
  end
end
