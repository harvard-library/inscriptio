class CreateFloors < ActiveRecord::Migration
  def self.up
    create_table :floors do |t|
      t.references :library
      t.string :name

      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :floors
  end
end
