class AddDeletedAtToSubjectAreas < ActiveRecord::Migration[4.2]
  def change
    add_column :subject_areas, :deleted_at, :datetime
  end
end
