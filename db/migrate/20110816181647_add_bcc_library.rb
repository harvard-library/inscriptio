class AddBccLibrary < ActiveRecord::Migration
  def self.up
    add_column :libraries, :bcc, :string
  end

  def self.down
    remove_column :bcc
  end
end
