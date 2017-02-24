class Admin::UsersController < AdminController
  def index
    @users = User.order(:last_name)
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
