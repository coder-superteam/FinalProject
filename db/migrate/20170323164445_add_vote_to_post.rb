class AddVoteToPost < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :vote_number, :integer
  end
end
