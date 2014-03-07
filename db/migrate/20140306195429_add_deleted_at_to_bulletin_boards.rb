class AddDeletedAtToBulletinBoards < ActiveRecord::Migration
  def change
    add_column :bulletin_boards, :deleted_at, :datetime
  end
end
