class CreateLibrariesUsersAdminPermissions < ActiveRecord::Migration
  def change
    create_table :libraries_users_admin_permissions, :id => false do |t|
      t.integer :user_id, :null => false    # fkey: users.id
      t.integer :library_id, :null => false # fkey: libraries.id
    end
    add_index :libraries_users_admin_permissions, :user_id
    add_index :libraries_users_admin_permissions, :library_id
  end
end
