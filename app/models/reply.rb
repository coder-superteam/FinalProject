class Reply < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_many :votes
  validates :body, presence: true
end
