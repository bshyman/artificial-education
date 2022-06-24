class SimpleMathProblemsService

  def new_multiplication_questions
    url = simple_math_url(operator: 'multiplication')
    questions = send_request(url)
    save_questions(questions)
    # questions
    # SimpleMathQuestion.all.sample(10).map{|q| { question: q.content, correct_answer: q.correct_answer, incorrect_answers: q.incorrect_answers }.stringify_keys}
  end

  def send_request(url)
    headers = {
      "X-RapidAPI-Host": 'simple-math-problems.p.rapidapi.com',
      "X-RapidAPI-Key": '7f69f7707amsh29d7357f123c46ep1ecc7ajsnb6261b4982dd'
    }
    response = HTTParty.get(url, headers: headers)
    response.parsed_response
  end

  def simple_math_url(operator:)
    "https://simple-math-problems.p.rapidapi.com/#{operator}/single"
  end

  def save_questions(questions)
    questions.each do |question|
      Question.find_or_create_by!(game_id: Game.simple_math.id, content: question['question'], correct_answer: question['correctAnswer'], incorrect_answers: question['incorrectAnswers'])
    end
  end
end
