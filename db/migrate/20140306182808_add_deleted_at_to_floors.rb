class AddDeletedAtToFloors < ActiveRecord::Migration
  def change
    add_column :floors, :deleted_at, :datetime
  end
end
