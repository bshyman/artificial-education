# frozen_string_literal: true

class TriviaQuestion < Question
  before_save do
    self.question_type = 'TriviaQuestion'
    self.game_id = Game.trivia.id
  end

  def answers
    incorrect_answers.push(correct_answer).shuffle
  end
end
