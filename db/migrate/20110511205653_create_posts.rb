class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.references :bulletin_board
      t.references :user
      t.datetime :creation_time
      t.text :message
      t.string :media
      t.boolean :public, :default => true
      t.timestamps
    end
    
    [:bulletin_board_id, :user_id, :creation_time].each do|col|
      add_index :posts, col
    end
  end

  def self.down
    drop_table :posts
  end
end
