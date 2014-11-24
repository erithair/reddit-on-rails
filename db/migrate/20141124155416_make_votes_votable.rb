class MakeVotesVotable < ActiveRecord::Migration
  def change
    add_column :votes, :votable_id, :integer
    add_column :votes, :votable_type, :string
    add_index :votes, [:votable_id, :votable_type]
    add_index :votes, [:user_id, :votable_id, :votable_type], unique: true
  end
end
