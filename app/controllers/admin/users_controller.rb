class Admin::UsersController < AdminController
  def index
    @users = User.order(:last_name)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_users_path, notice: 'User has been created'
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    user = User.find(params[:id])
    if user.update!(user_params)
      redirect_to admin_users_path, notice: 'User has been updated'
    else
      @user = user
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :membership, :role, :password, :password_confirmation)
  end
end
