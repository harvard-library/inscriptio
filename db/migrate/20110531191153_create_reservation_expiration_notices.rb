class CreateReservationExpirationNotices < ActiveRecord::Migration
  def self.up
    create_table :reservation_expiration_notices do |t|
      t.string :type
      t.integer :days_before_expiration
      t.string :subject, :limit => 250
      t.text :message
      t.string :reply_to
      t.timestamps
    end
    
    add_index :reservation_expiration_notices, :type
  end

  def self.down
    drop_table :reservation_expiration_notices
  end
end
