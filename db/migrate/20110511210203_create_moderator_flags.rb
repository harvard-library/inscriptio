class CreateModeratorFlags < ActiveRecord::Migration
  def self.up
    create_table :moderator_flags do |t|
      t.references :post
      t.references :user
      t.string :reason, :null => false
      t.timestamps
    end
    
    [:post_id, :user_id, :reason].each do|col|
      add_index :moderator_flags, col
    end
  end

  def self.down
    drop_table :moderator_flags
  end
end
