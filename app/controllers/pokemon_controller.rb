class PokemonController < ApplicationController
  layout 'pokemon'

  def index
  end

  def new_question
    question = MissingLetterQuestion.new.generate

    partial = render_to_string(partial: 'pokemon_spellcheck_question', locals: {question: question})
    render json: {
      partial: partial,
      question: question
    }, status: :ok
  end

  def show
  end

  def pokedex
    @pokemon = Pokemon.all.to_json
  end
end
