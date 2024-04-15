class UsersController < ApplicationController
  def new
    @user = User.new(last_name: current_user.last_name)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if user_params[:birthday].present?
      @user.birthday = Date.strptime(user_params[:birthday], '%m/%d/%Y')
    end

    if @user.update(user_params)
      redirect_to users_path, notice: 'User was successfully updated.'
    else
      render 'edit'
    end
  end

  def show
    @user = User.find(params[:id])
  end


  def create
    @user = User.new(user_params)
    @user.group_id = current_user.group_id
    @user.role = 'player'
    if user_params[:birthday].present?
      @user.birthday = Date.strptime(user_params[:birthday], '%m/%d/%Y')
    end

    if @user.save
      redirect_to users_path, notice: 'User was successfully created.'
    else
      render 'new'
    end
  end

  def sign_in
    render 'sign-in'
  end

  def index
  end

  def update_xp
    current_player.update(xp: current_player.xp + user_params[:xp].to_i)
    render json: { xp: current_player.xp, level: current_player.level, level_progress: current_player.level_progress }, status: :ok
  end

  def destroy
    @user = User.find(params[:id])
    if @user.last_group_member?
      redirect_to users_path, notice: 'User is the last member of a group and cannot be deleted.'
      return
    end
    @user.destroy

    redirect_to users_path, notice: 'User was successfully deleted.'
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :birthday, :xp)
  end
end
