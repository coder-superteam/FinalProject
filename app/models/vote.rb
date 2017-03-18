class Vote < ApplicationRecord
  belongs_to :post
  belongs_to :reply
  belongs_to :user
end
