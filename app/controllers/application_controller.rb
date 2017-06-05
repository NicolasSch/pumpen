class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  check_authorization unless: :devise_controller?
  rescue_from CanCan::AccessDenied, with: :access_denied_handler

  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    update_attrs = [:password, :password_confirmation, :current_password]
    devise_parameter_sanitizer.permit :account_update, keys: update_attrs
  end

  private

  def access_denied_handler
    redirect_to :root, alert: t('access_denied')
  end
end
