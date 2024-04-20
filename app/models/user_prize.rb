class UserPrize < ApplicationRecord
  delegate :name, :cost, to: :prize, prefix: true
  delegate :bank, to: :user, prefix: true

  belongs_to :user
  belongs_to :prize
end
