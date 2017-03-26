class UsersController < ApplicationController
  def edit
    @user = current_user
    authorize! :write, @user
  end

  def update
    @user = current_user
    authorize! :write, @user

    if (params[:password].present? ? @user.update_with_password(user_params) : @user.update(user_params))
      redirect_to edit_user_path(@user), notice: t('user.profile.notice.save')
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :email,
      :current_password,
      :password,
      :password_confirmation
    )
  end
end
