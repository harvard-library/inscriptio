class AddBccLibrary < ActiveRecord::Migration[4.2]
  def self.up
    add_column :libraries, :bcc, :string
    add_column :libraries, :from, :string
  end

  def self.down
    remove_column :libraries, :bcc
    remove_column :libraries, :from
  end
end