class AddVoteNumberToReply < ActiveRecord::Migration[5.0]
  def change
    add_column :replies, :vote_number, :integer
  end
end
