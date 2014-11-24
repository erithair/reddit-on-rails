class RemoveColumnFromVotes < ActiveRecord::Migration
  def change
    remove_index :votes, [:link_id, :user_id]
    remove_column :votes, :link_id, :integer
  end
end
