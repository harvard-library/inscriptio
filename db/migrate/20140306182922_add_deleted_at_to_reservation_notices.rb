class AddDeletedAtToReservationNotices < ActiveRecord::Migration[4.2]
  def change
    add_column :reservation_notices, :deleted_at, :datetime
  end
end
