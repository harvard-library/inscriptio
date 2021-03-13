class DropStatuses < ActiveRecord::Migration[4.2]
  def up
    drop_table :statuses
  end

  def down
    create_table :statuses do |t|
      t.string :name, :null => false
      t.timestamps
    end
    Status.to_hash.each do |k,v|
      execute <<-SQL
        INSERT INTO statuses(name, created_at, updated_at) VALUES('#{k}', NOW(), NOW());
      SQL
    end
    res = ActiveRecord::Base.connection.query('SELECT name, id FROM statuses;')
    bad = []
    res.each do |s_in_db|
      bad.push(s_in_db) if Status[s_in_db[0]] != s_in_db[1].to_i
    end
    raise "Statuses with bad IDs: #{bad.join(', ')}\n" if !bad.empty?
  end
end
