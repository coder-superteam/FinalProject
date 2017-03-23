class Vote < ApplicationRecord
  belongs_to :post, optional: true
  belongs_to :reply, optional: true
  belongs_to :user
end
