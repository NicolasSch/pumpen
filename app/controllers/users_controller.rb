# frozen_string_literal: true

class UsersController < ApplicationController
  def edit
    @user = current_user
    @bills = @user.bills
    authorize! :write, @user
  end

  def update
    @user = User.find(params[:id])
    authorize! :write, @user

    if update_user
      bypass_sign_in(@user)
      redirect_to edit_user_path(@user), notice: @notice
    else
      @bills = @user.bills
      flash[:alert] = t('user.profile.alert')
      render :edit
    end
  end

  private

  def update_user
    if save_password?
      @notice = t('user.profile.password_save')
      @user.update_with_password(user_params) if validate_password_params
    else
      @notice = t('user.profile.data_save')
      @user.update(user_params.except(:password, :current_password, :password_confirmation))
    end
  end

  def save_password?
    user_params.key?(:password) ||
      user_params.key?(:password_confirmation) ||
      user_params.key?(:current_password)
  end

  def validate_password_params
    @user.errors.add(:current_password, :blank)       if user_params[:current_password].blank?
    @user.errors.add(:password, :blank)               if user_params[:password].blank?
    @user.errors.add(:password_confirmation, :blank)  if user_params[:password_confirmation].blank?
    @user.errors.none?
  end

  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :email,
      :current_password,
      :password,
      :password_confirmation,
      :iban,
      :bic,
      :bank
    )
  end
end
