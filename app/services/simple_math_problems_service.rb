# frozen_string_literal: true

class SimpleMathProblemsService
  def multiplication_questions(count: 10)
    count.times.map do
      int1 = rand(1..10)
      int2 = rand(1..10)
      correct = int1 * int2
      {
        question: "What is #{int1} x #{int2}?",
        correct_answer: correct.to_s,
        incorrect_answers: generate_incorrect_answers(correct),
        all_answers: [correct.to_s, generate_incorrect_answers(correct)].flatten.shuffle
      }
    end
  end

  def generate_incorrect_answers(correct)
    answers = []
    until answers.length == 3 do
      # tighten the range of incorrect answers so its not too easy
      answer = rand((correct - 10)..(correct + 10)).to_s
      next if answers.include?(answer) || answer == correct || answer.to_i.negative?

      answers << answer
    end
    answers
  end
end
