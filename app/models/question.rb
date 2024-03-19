# frozen_string_literal: true

class Question < ApplicationRecord
  self.inheritance_column = :question_type

  VALID_DIFFICULTIES = %w[easy medium hard].freeze
  validates :incorrect_answers, presence: true, length: { minimum: 3, maximum: 3, message: 'must be unique' }
  validates :correct_answer, presence: true
  validates :difficulty, presence: true, inclusion: { in: VALID_DIFFICULTIES }
  validates :content, presence: true, uniqueness: true

  def generate(args = {})
    case args[:type]
    when 'missing_letter'
      missing_letter_question_hash(random_pokemon, user_id: args[:current_user_id])
    when 'addition'
      addition_question
    when 'multiplication'
    else
      raise "Can't generate question without type!"
    end
  end

  def save_questions(questions, game_id)
    questions.each do |question|
      Question.find_or_create_by!(
        game_id: game_id,
        content: question[:question],
        correct_answer: question[:correct],
        incorrect_answers: question[:incorrect_answers])
    end
  end

  def missing_letter_question_hash(pokemon, current_user_id)
    chars   = pokemon.name.chars
    correct = chars.sample
    answers = [correct]
    while answers.size < 9
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
