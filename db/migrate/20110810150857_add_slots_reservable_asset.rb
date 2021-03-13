class AddSlotsReservableAsset < ActiveRecord::Migration[4.2]
  def self.up
    add_column :reservable_assets, :slots, :string
  end

  def self.down
    remove_column :reservable_assets, :slots
  end
end
