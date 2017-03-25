class Message < ApplicationRecord
	validates :body, presence: true, length: {minimum: 2, maximum: 1000}
	belongs_to :user
	belongs_to :room

	def timestamp
		created_at.strftime('%H:%M:%S %d %B %Y')
	end
end
