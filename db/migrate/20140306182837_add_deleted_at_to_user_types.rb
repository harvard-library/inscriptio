class AddDeletedAtToUserTypes < ActiveRecord::Migration
  def change
    add_column :user_types, :deleted_at, :datetime
  end
end
