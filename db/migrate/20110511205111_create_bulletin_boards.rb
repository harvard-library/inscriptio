class CreateBulletinBoards < ActiveRecord::Migration
  def self.up
    create_table :bulletin_boards do |t|
      t.references :reservable_asset
      t.string :post_lifetime
      t.timestamps
    end
    
    [:reservable_asset_id].each do|col|
      add_index :bulletin_boards, col
    end
  end

  def self.down
    drop_table :bulletin_boards
  end
end
