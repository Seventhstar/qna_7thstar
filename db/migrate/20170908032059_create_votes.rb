class CreateVotes < ActiveRecord::Migration[5.1]
  def change
    create_table :votes do |t|
      t.references :user, foreign_key: true
      t.integer :votable_id
      t.string :votable_type
      t.integer :val

      t.timestamps
    end
    
    add_index :votes, [:votable_id, :votable_type]
    add_index :votes, [:votable_id, :votable_type, :user_id], unique: true
  end
end
