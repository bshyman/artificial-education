class SimpleMathQuestion < Question
  serialize :incorrect_answers, array: true
  # validates :incorrect_answers, presence: true
  validates :content, presence: true
end
