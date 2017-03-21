class Post < ApplicationRecord
	belongs_to :user
	has_many :replies
	validates :title, :language, :body, presence: true
	def self.search(search)
	  where("LOWER(title) LIKE ?", "%#{search.downcase}%")
	end
end
