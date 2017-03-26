class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  check_authorization unless: :devise_controller?

  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    update_attrs = [:password, :password_confirmation, :current_password]
    devise_parameter_sanitizer.permit :account_update, keys: update_attrs
  end

  def ensure_cart
    Cart.create!(user: current_user) unless current_user.cart.present?
  end

  def set_cart
    @cart = params[:cart_id].present? ? Cart.find(params[:cart_id]) : current_user.cart
  end
end
