class UserPrize < ApplicationRecord
  delegate :name, :cost, to: :prize, prefix: true

  belongs_to :user
  belongs_to :prize
end
