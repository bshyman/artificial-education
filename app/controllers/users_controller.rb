class UsersController < ApplicationController
  def new
    @user = User.new(last_name: current_user.last_name)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    @user.birthday = Date.strptime(user_params[:birthday], '%m/%d/%Y') if user_params[:birthday].present?

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
    @user.role = 'basic'
    @user.birthday = Date.strptime(user_params[:birthday], '%m/%d/%Y') if user_params[:birthday].present?

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
    bank = current_user.bank + user_params[:xp].to_i
    current_player.update(xp: current_player.xp + user_params[:xp].to_i, bank:)
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

  def authenticate
    @user = User.find_by(id: params[:id])
    return render json: { success: true }, status: :ok if @user.password_digest.blank?

    if @user&.authenticate(params[:password])
      session[:user_id] = @user.id
      render json: { success: true }, status: :ok
    else
      render json: { success: false, errors: 'Incorrect password' }, status: :unauthorized
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :password, :password_confirmation, :birthday, :xp)
  end
end
