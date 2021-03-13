class AddDeletedAtToBulletinBoards < ActiveRecord::Migration[4.2]
  def change
    add_column :bulletin_boards, :deleted_at, :datetime
  end
end
