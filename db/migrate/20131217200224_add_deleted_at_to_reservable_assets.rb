class AddDeletedAtToReservableAssets < ActiveRecord::Migration[4.2]
  def change
    add_column :reservable_assets, :deleted_at, :datetime
  end
end
