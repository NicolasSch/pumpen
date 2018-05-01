
# frozen_string_literal: true

class Admin::UsersController < AdminController
  include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper

  def index
    users_scope = params[:archived] == '1' ? User.archived : User.active
    users_scope = users_scope.name_like(params[:filter]) if params[:filter].present?
    @users = smart_listing_create(:users, users_scope, partial: 'admin/users/user', default_sort: { last_name: 'asc' })
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_users_path, notice: t('admin.users.notice.created')
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
      redirect_to admin_users_path, notice: t('admin.users.notice.updated')
    else
      @user = user
      render :edit
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy!
    redirect_to admin_users_path, notice: t('admin.users.notice.destroy')
  end

  private

  def show_archived?
    params['archived'] == 'true'
  end

  def user_params
    params.require(:user).permit(
      :first_name, :last_name, :email,
      :membership, :gender, :street,
      :zip, :city, :member_number,
      :role, :password, :password_confirmation,
      :archived
    )
  end
end
