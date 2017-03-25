class CreateVotes < ActiveRecord::Migration[5.0]
  def change
    create_table :votes do |t|
      t.integer :vote_type
      t.integer :vote_action
      t.references :post, foreign_key: true
      t.references :reply, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
