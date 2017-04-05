class Reply < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_many :votes
  has_many :comments
  validates :body, presence: true

  def self.voted(user_id, reply_id)
		@votes = Vote.where(user_id: user_id, reply_id: post_id).all
		@result = 0
		@votes.each do |vote|
			@result += vote.vote_action
		end
		@result
	end

	def self.count_vote(reply_id)
		@votes = Vote.where(reply_id: reply_id).all
		@result = 0
		@votes.each do |vote|
			@result += vote.vote_action
		end
		@result
	end

end
