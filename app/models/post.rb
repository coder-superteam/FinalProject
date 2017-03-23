class Post < ApplicationRecord
	belongs_to :user
	has_many :replies
	has_many :votes
	validates :title, :language, :body, presence: true
	def self.search(search)
	  where("LOWER(title) LIKE ?", "%#{search.downcase}%")
	end

	def self.voted(user_id, post_id)
		@votes = Vote.where(user_id: user_id, post_id: post_id).all
		@result = 0
		@votes.each do |vote|
			@result += vote.vote_action
		end
		@result
	end
end
