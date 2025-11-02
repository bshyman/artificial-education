class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question, optional: true
  belongs_to :round

  validates :content, presence: true
  validates :is_correct, inclusion: { in: [true, false] }
end
