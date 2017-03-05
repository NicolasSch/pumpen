class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  check_authorization unless: :devise_controller?

  def ensure_cart
    Cart.create!(user: current_user) unless current_user.cart.present?
  end

  def set_cart
    @cart = params[:cart_id].present? ? Cart.find(params[:cart_id]) : current_user.cart
  end
end
