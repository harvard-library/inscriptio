class AddDeletedAtToReservableAssetTypes < ActiveRecord::Migration[4.2]
  def change
    add_column :reservable_asset_types, :deleted_at, :datetime
  end
end
