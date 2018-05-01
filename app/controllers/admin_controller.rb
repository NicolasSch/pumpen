# frozen_string_literal: true

class AdminController < ActionController::Base
  before_action :authenticate_user!
  before_action :ensure_admin

  private

  def ensure_admin
    redirect_to :root, notice: t('admin.access_denied') unless current_user.admin?
  end
end
