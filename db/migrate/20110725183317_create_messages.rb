class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.string :title, :null => false
      t.text :content, :null => false
      t.string :description
      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end
