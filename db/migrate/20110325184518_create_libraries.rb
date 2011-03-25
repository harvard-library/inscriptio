class CreateLibraries < ActiveRecord::Migration
  def self.up
    create_table :libraries do |t|
      t.string :name
      t.string :url
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :state
      t.string :zip
      t.string :latitude
      t.string :longitude
      t.text :contact_info
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :libraries
  end
end
