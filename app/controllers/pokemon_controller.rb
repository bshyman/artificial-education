class PokemonController < ApplicationController
  layout 'pokemon'
  
  def index
  
  end
  
  def new_question
    @question = Question.new
  end
  
  def show
  
  end
end
