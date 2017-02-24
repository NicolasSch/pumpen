class AdminController < ActionController::Base
  before_action :authenticate_user!
  before_action :ensure_admin

  private

  def ensure_admin
    redirect_to :root unless current_user.admin?
  end
end
