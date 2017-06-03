class ProductsController < ApplicationController
  before_action :ensure_cart, :set_cart

  def index
    authorize! :read, Product
    @products = Product.order(:title)
    @tab_item = TabItem.new
  end

  private

  def ensure_cart
    Cart.create!(user: current_user) unless current_user.cart.present?
  end

  def set_cart
    @cart = current_user.cart
  end
end
