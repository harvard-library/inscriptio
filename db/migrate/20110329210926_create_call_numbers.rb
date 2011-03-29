class CreateCallNumbers < ActiveRecord::Migration
  def self.up
    create_table :call_numbers do |t|
      t.string :call_number
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :call_numbers
  end
end
