class UsersController < ApplicationController
  def sign_in
    render 'sign-in'
  end
  def index
  end

  def update_xp
    current_player.update(xp: current_player.xp + user_params[:xp].to_i)
    render json: { xp: current_player.xp, level: current_player.level, level_progress: current_player.level_progress }, status: :ok
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :birthday, :xp)
  end
end
