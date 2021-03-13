class AddDeletedAtToFloors < ActiveRecord::Migration[4.2]
  def change
    add_column :floors, :deleted_at, :datetime
  end
end
