class CreateFloors < ActiveRecord::Migration
  def self.up
    create_table :floors do |t|
      t.references :library
      t.string :name, :null => false
      t.integer :position
      t.string :floor_map

      t.timestamps
    end

    [:library_id, :position, :floor_map].each do|col|
      add_index :floors, col
    end

  end

  def self.down
    drop_table :floors
  end
end
