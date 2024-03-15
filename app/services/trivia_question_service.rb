# frozen_string_literal: true

class TriviaQuestionService
  BASE_URL = 'https://opentdb.com/api.php'
  attr_reader :difficulty

  def initialize(difficulty: nil)
    @difficulty = difficulty
  end

  def random_questions(amount: 10)
    base_query = @difficulty ? TriviaQuestion.where(difficulty: @difficulty) : TriviaQuestion.all
    base_query.order(Arel.sql('RANDOM()')).limit(amount)
  end

  def import_new_questions
    fetch_questions.each do |question|
      question_params = {
        content: question['question'],
        answers: question['incorrect_answers'] + [question['correct_answer']],
        correct_answer: question['correct_answer'],
        difficulty: question['difficulty']
      }
      TriviaQuestion.find_or_create_by!(question_params)
    end
  end

  def fetch_questions
    params = { amount: 50 }
    params[:difficulty] = @difficulty if @difficulty
    response = HTTParty.get(BASE_URL, query: params)
    response['results']
  end
end
