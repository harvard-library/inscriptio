class CreateBulletinBoards < ActiveRecord::Migration
  def self.up
    create_table :bulletin_boards do |t|
      t.references :reservable_asset
      t.string :post_lifetime
      t.timestamps
    end
    
      add_index :bulletin_boards, :reservable_asset_id
  end

  def self.down
    drop_table :bulletin_boards
  end
end
