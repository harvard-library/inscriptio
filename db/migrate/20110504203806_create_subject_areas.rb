class CreateSubjectAreas < ActiveRecord::Migration
  def self.up
    create_table :subject_areas do |t|
      t.string :name, :null => false
      t.string :description
      t.timestamps
    end
    
    add_index :subject_areas, :name

    create_table(:subject_areas_floors, :id => false) do|t|
      t.references :subject_area
      t.references :floor
    end

    [:subject_area_id, :floor_id].each do|col|
      add_index :subject_areas_floors, col
    end
  end

  def self.down
    drop_table :subject_areas
    drop_table :subject_areas_floors
  end
end
