class AddDeletedAtToSubjectAreas < ActiveRecord::Migration
  def change
    add_column :subject_areas, :deleted_at, :datetime
  end
end
