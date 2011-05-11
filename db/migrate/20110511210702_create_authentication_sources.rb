class CreateAuthenticationSources < ActiveRecord::Migration
  def self.up
    create_table :authentication_sources do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :authentication_sources
  end
end
