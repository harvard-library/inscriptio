class AddDeletedAtToReservableAssets < ActiveRecord::Migration
  def change
    add_column :reservable_assets, :deleted_at, :datetime
  end
end
