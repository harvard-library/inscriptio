class CreateLibraries < ActiveRecord::Migration
  def self.up
    create_table :libraries do |t|
      t.string :name, :null => false
      t.string :url
      t.string :address_1, :null => false
      t.string :address_2
      t.string :city, :null => false
      t.string :state, :null => false
      t.string :zip, :null => false
      t.string :latitude
      t.string :longitude
      t.text :contact_info
      t.text :description
      t.text :tos

      t.timestamps
    end
  end

  def self.down
    drop_table :libraries
  end
end
