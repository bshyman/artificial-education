class ApplicationController < ActionController::Base
  helper_method :current_user, :current_player
  before_action :load_players
  # before_action :authorize_player

  before_action :authorize_player, except: :landing

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def current_player
    @current_player ||= current_user
  end

  def authorize_player
    redirect_to landing_path unless current_player.present?
  end

  def load_players
    @players = User.all.order(birthday: :asc)
  end

  def switch_user
    user = User.find_by(id: params.dig(:user, :id))
    @current_player = user
    session[:user_id] = @current_player.id
    render json: { player: @current_player, success: true }, status: :ok
  end

  def current_group
    @current_group ||= Group.first
  end
end
