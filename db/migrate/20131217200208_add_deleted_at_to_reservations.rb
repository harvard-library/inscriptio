class AddDeletedAtToReservations < ActiveRecord::Migration[4.2]
  def change
    add_column :reservations, :deleted_at, :datetime
  end
end
