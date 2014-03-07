class AddDeletedAtToReservableAssetTypes < ActiveRecord::Migration
  def change
    add_column :reservable_asset_types, :deleted_at, :datetime
  end
end
