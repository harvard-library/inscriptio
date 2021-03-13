class AddDeletedAtToLibraries < ActiveRecord::Migration[4.2]
  def change
    add_column :libraries, :deleted_at, :datetime
  end
end
