class Round < ApplicationRecord
  belongs_to :player, class_name: 'User', foreign_key: 'user_id'
  belongs_to :game
  has_many :answers, dependent: :destroy

  scope :user_rounds, ->(user_id) { where(user_id:) }

  delegate :name, to: :player, prefix: true
end
