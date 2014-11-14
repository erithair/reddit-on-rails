class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :user_id
      t.integer :link_id
      t.integer :up

      t.timestamps
    end
    add_index :votes, :user_id
    add_index :votes, :link_id
    add_index :votes, [:link_id, :user_id], unique: true
  end
end
