class AddSlotReservation < ActiveRecord::Migration
  def self.up
    add_column :reservations, :slot, :string
  end

  def self.down
    remove_column :reservations, :slot
  end
end
