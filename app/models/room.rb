class Room < ApplicationRecord
	validates :name , presence: true, uniqueness: true
	belongs_to :user
	has_many :messages, dependent: :destroy, inverse_of:	:room
end
