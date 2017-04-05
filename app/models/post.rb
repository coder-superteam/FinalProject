class Post < ApplicationRecord
	belongs_to :user
	has_many :replies
	has_many :votes
	has_many :comments
	validates :title, presence: true
	validates_presence_of :body, :if => :dont_have_image?

  mount_uploader :image, ImageUploader


	def self.search(search)
	  where("LOWER(body) LIKE ?", "%#{search[0].downcase}%")
	end

	def self.voted(user_id, post_id)
		@votes = Vote.where(user_id: user_id, post_id: post_id).all
		@result = 0
		@votes.each do |vote|
			@result += vote.vote_action
		end
		@result
	end

	def image_path_or_image
    image_path.presence || image
  end

  def count_reply(post_id)
  	Reply.where(post_id:post_id).count
  end

  def self.get_last_10_posts()

  end

  private
  	def dont_have_image?
  		image.nil? || image.blank?
  	end

	# def self.count_vote(post_id)
	# 	@votes = Vote.where(post_id: post_id).all
	# 	@result = 0
	# 	@votes.each do |vote|
	# 		@result += vote.vote_action
	# 	end
	# 	@result
	# end
end
