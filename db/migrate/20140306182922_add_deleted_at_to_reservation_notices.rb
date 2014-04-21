class AddDeletedAtToReservationNotices < ActiveRecord::Migration
  def change
    add_column :reservation_notices, :deleted_at, :datetime
  end
end
