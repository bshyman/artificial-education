class GamesController < ApplicationController
  def index
  end
  
  def start
    @game = Game.find(params[:id])
    session[:games][@game.id] = @game.initialize_score_map
  end
end
