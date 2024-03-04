# frozen_string_literal: true

class SimpleMathProblemsService

  def new_multiplication_questions
    save_questions(questions)
  end

  def save_questions(questions)
    questions.each do |question|
      Question.find_or_create_by!(
        game_id: Game.simple_math.id,
        content: question[:question],
        correct_answer: question[:correct],
        incorrect_answers: question[:incorrect_answers])
    end
  end

  def questions
    10.times.map do
      int1 = rand(1..10)
      int2 = rand(1..10)
      correct = int1 * int2
      {
        question: "What is #{int1} x #{int2}?",
        correct: correct.to_s,
        incorrect_answers: generate_incorrect_answers(correct)
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
