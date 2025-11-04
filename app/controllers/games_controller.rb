class GamesController < ApplicationController
  before_action :authenticate_super, except: :index
  def index
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(game_params)
    if @game.save
      redirect_to new_game_path
    else
      render :new
    end
  end

  def edit
    @game = Game.find(params[:id])
  end

  def start
    @game = Game.find(params[:id])
    session[:games][@game.id] = @game.initialize_score_map
  end

  def destroy
    @game = Game.find(params[:id])
    @game.destroy
    respond_to do |format|
      format.json { render json: { redirect_url: new_game_path }, status: :ok }
    end
  end

  private

  def game_params
    params.require(:game).permit(:name)
  end
end
