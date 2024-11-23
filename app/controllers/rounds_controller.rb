class RoundsController < ApplicationController
  def pokemon_new
    if session.dig(:games, :pokemon_spellcheck)
      round = Round.where(game_id: Game.pokemon_spellcheck.id, user_id: current_user.id)
      last_question = round.questions.last
      @question = last_question.answered? ? MissingLetterQuestion.new.generate : last_question
    else
      Round.create(game_id: Game.pokemon_spellcheck.id, user_id: current_user.id)
      @question = MissingLetterQuestion.new.generate
    end

    render 'pokemon_new', layout: 'pokemon'
  end

  def simple_math_new
    if session.dig(:games, :simple_math)
      round = Round.where(game_id: Game.simple_math.id, user_id: current_user.id)
      last_question = round.questions.last
    else
      Round.create(game_id: Game.simple_math.id, user_id: current_user.id)
      @questions = MultiplicationQuestion.new.generate
    end

    render 'simple_math', layout: 'simple_math'
  end

  def collections_new
    if session.dig(:games, :collections)
      round = Round.where(game_id: Game.collections.id, user_id: current_user.id)
      last_question = round.questions.last
    else
      Round.create(game_id: Game.collections.id, user_id: current_user.id)
      @collections = CollectionsService.new.generate
    end

    render 'collections_new'
  end

  def trivia
    if session.dig(:games, :trivia)
      round = Round.where(game_id: Game.trivia.id, user_id: current_user.id)
      last_question = round.questions.last
    else
      Round.create(game_id: Game.trivia.id, user_id: current_user.id)
      @questions = TriviaQuestionService.new.random_questions
      raise 'Not enough questions' if @questions.size < 10
    end
  end

  def state_selector
    @states_and_capitals = Rails.application.config_for(:states, env: 'production').to_json
    render 'games/state_selector'
  end
end
