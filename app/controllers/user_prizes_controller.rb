class UserPrizesController < ApplicationController

  # purchase
  def create
    @user_prize = UserPrize.new(user_prize_params)
    @user_prize.user_id = current_user.id
    @user_prize.purchased_at = Time.now
    begin
      deduct_points
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.tagged(e.class).error(e.message)
      return render json: { error: e.message }, status: :unprocessable_entity
    end

    if @user_prize.save
      render json: { user: { bank: @user_prize.user_bank } }, status: :ok
    else
      render 'new'
    end
  end

  def index
    @user_prizes = UserPrize.where(user_id: current_user.id)
  end

  def deduct_points
    user = User.find(current_user.id)
    prize = Prize.find(user_prize_params[:prize_id])
    user.update!(bank: user.bank - prize.cost)
  end

  private

  def user_prize_params
    params.require(:user_prize).permit(:prize_id)
  end
end
