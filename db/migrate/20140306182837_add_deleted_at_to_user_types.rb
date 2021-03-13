class AddDeletedAtToUserTypes < ActiveRecord::Migration[4.2]
  def change
    add_column :user_types, :deleted_at, :datetime
  end
end
