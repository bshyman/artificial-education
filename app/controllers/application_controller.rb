class ApplicationController < ActionController::Base
  helper_method :current_user, :current_player

  before_action :authorize_player, except: :landing

  def current_user
    @current_user ||= User.first
  end

  def current_player
    @current_player ||= Player.find_by(id: session[:player_id])
  end

  def authorize_player
    redirect_to landing_path unless current_player.present?
  end


end
