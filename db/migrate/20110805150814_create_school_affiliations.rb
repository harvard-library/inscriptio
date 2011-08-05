class CreateSchoolAffiliations < ActiveRecord::Migration
  def self.up
    create_table :school_affiliations do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :school_affiliations
  end
end
