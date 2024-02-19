class Question < ApplicationRecord
  QUESTION_TYPES = %w[missing_letter addition]

  def generate(args = {})
    case args[:type]
    when 'missing_letter'
      missing_letter_question_hash(random_pokemon, user_id: args[:current_user_id])
    when 'addition'
      addition_question
    when 'multiplication'
      @multiplication_questions = SimpleMathProblemsService.new.new_multiplication_questions
    else
      raise "Can't generate question without type!"
    end
  end

  def missing_letter_question_hash(pokemon, current_user_id)
    chars   = pokemon.name.chars
    correct = chars.sample
    answers = [correct]
    while answers.size < 9 do
      incorrect_answer = ('a'..'z').without(correct).sample
      next if answers.include?(incorrect_answer)
      answers << incorrect_answer
    end
    answers.shuffle!
    # round = Game.pokemon_spellcheck.rounds.where(user_id: current_user_id).last

    {
      name: pokemon.name,
      id: pokemon.id,
      question: 'Which letter is missing?',
      answers: answers,
      correct: correct
    }
  end
  
  def answered?
    submitted_answer.present?
  end


  def random_pokemon
    pokemon = nil
    while pokemon.nil?
      random_pokedex_id = rand(900)
      pokemon           = Pokemon.find_by_pokedex_id(random_pokedex_id)
    end
    pokemon
  end

  def addition_question
    correct = 21
    until correct < 20
      var1    = rand(1..15)
      var2    = rand(1..15)
      correct = var1 + var2
    end

    answers = [correct]
    until answers.size == 4
      answers << rand(4..15)
      answers.uniq!
    end
    { question: "#{var1} + #{var2}", answers: answers, answer: correct, }
  end
end
