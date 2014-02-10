class UserTypesUsersManyToMany < ActiveRecord::Migration
  class UserType < ActiveRecord::Base
    # Local class to avoid validations, etc.
    has_and_belongs_to_many :reservable_asset_types
  end
  class ReservableAssetType < ActiveRecord::Base
    # Local class to avoid validations, etc.
    has_and_belongs_to_many :user_types
  end
  def up
    # Join table for Users -> HABTM <- UserTypes association
    create_table :user_types_users, :id => false do |t|
      t.references :user, :null => false
      t.references :user_type, :null => false
    end
    add_index :user_types_users, ["user_id", "user_type_id"], :unique => true

    # Column for Library -> has_many -> UserTypes association
    add_column :user_types, :library_id, :integer
    UserType.reset_column_information
    ReservableAssetType.reset_column_information
    UserType.all.each do |ut|
      new_uts = []
      rats = ut.reservable_asset_types.group_by(&:library_id)
      Library.all.each do |l|
        new_uts << UserType.create(ut.attributes.except("id", "updated_at", "reservable_asset_types").merge(:library_id => l.id, :updated_at => Time.now, :reservable_asset_types =>  rats[l.id] ? rats[l.id] : []))
      end
      UserType.clear_cache!
      User.where(:user_type_id => ut.id).each do |u|
        my_type_ids = new_uts.map(&:id)
        my_type_ids.each do |t|
          execute <<-SQL
            INSERT INTO user_types_users(user_id, user_type_id) VALUES(#{u.id}, #{t});
          SQL
        end
      end
      ut.destroy
    end

    remove_column :users, :user_type_id

    # Once the old user types are destroyed, no user types without a library ID are allowed
    change_column :user_types, :library_id, :integer, :null => false

    add_index :user_types_users, "user_type_id"
    add_index :user_types_users, "user_id"
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Unable to fit Many-to-Many data into One-to-One data model"
  end
end
