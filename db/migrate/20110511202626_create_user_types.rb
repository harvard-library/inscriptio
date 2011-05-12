class CreateUserTypes < ActiveRecord::Migration
  def self.up
    create_table :user_types do |t|
      t.string :name, :null => false
      t.timestamps
    end
    
    add_index :user_types, :name
  end

  def self.down
    drop_table :user_types
  end
end
