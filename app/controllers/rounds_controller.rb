class RoundsController < ApplicationController
  def pokemon_new
    if session.dig(:games, :pokemon_spellcheck)
      round = Round.where(game_id: Game.pokemon_spellcheck.id, user_id: current_user.id)
      last_question = round.questions.last
      if last_question.answered?
        @question = Question.new.generate({ type: 'missing_letter' })
      else
      
      end
      
    end
    
    render 'pokemon_new', layout: 'pokemon'
  end

  def simple_math_new
    if session.dig(:games, :simple_math)
      round = Round.where(game_id: Game.simple_math.id, user_id: current_user.id)
      last_question = round.questions.last
    else
      Round.create(game_id: Game.simple_math.id, user_id: current_user.id)
      @questions = SimpleMathQuestion.new.generate(type: 'multiplication')
    end

    render 'simple_math', layout: 'simple_math'
  end
end
