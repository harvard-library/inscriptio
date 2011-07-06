class CreateReservationNotices < ActiveRecord::Migration
  def self.up
    create_table :reservation_notices do |t|
      t.references :status
      t.string :subject, :limit => 250
      t.text :message
      t.string :reply_to
      t.timestamps
    end
  end

  def self.down
    drop_table :reservation_notices
  end
end
