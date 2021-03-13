class AddDeletedAtToCallNumbers < ActiveRecord::Migration[4.2]
  def change
    add_column :call_numbers, :deleted_at, :datetime
  end
end
