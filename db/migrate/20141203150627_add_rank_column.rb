class AddRankColumn < ActiveRecord::Migration
  def change
    add_column :links, :rank, :integer, default: 0, null: false
    add_column :comments, :rank, :integer, default: 0, null: false
  end
end
