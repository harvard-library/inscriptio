class CreateCallNumbers < ActiveRecord::Migration
  def self.up

    create_table :call_numbers do |t|
      t.references :subject_area
      t.string :call_number, :null => false, :limit => 50
      t.string :long_name
      t.string :description

      t.timestamps
    end
    
    [:subject_area_id, :call_number].each do|col|
      add_index :call_numbers, col
    end

    create_table(:call_numbers_floors, :id => false) do|t|
      t.references :call_number
      t.references :floor
    end

    [:call_number_id, :floor_id].each do|col|
      add_index :call_numbers_floors, col
    end
  end

  def self.down
    drop_table :call_numbers
    drop_table :call_numbers_floors
  end
end
