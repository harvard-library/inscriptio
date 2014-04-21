class AddDeletedAtToCallNumbers < ActiveRecord::Migration
  def change
    add_column :call_numbers, :deleted_at, :datetime
  end
end
