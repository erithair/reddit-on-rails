class AddCounterCacheColumns < ActiveRecord::Migration
  def change
    add_column :links, :comments_count, :integer, default: 0
    add_column :users, :links_count, :integer, default: 0
    add_column :users, :comments_count, :integer, default: 0
  end
end
