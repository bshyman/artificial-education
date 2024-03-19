# frozen_string_literal: true
class MultiplicationQuestion < Question
  serialize :incorrect_answers, array: true
  # validates :content, presence: true

  def generate
    @multiplication_questions = SimpleMathProblemsService.new.multiplication_questions
  end
end
