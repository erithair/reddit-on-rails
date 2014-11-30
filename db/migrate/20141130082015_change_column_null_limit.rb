class ChangeColumnNullLimit < ActiveRecord::Migration
  def up
    change_column_null :users, :links_count, false
    change_column_null :users, :comments_count, false
    change_column_null :links, :comments_count, false
  end

  def down
    change_column_null :users, :links_count, true
    change_column_null :users, :comments_count, true
    change_column_null :links, :comments_count, true
  end
end
