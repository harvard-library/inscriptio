class IndexPostsOnCreatedAt < ActiveRecord::Migration[4.2]
  def change
    add_index :posts, :created_at
  end
end
