class Round < ApplicationRecord
  belongs_to :user
  scope :user_rounds, ->(user_id) { where(user_id: user_id) }
end
