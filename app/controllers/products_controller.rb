class ProductsController < ApplicationController
  before_action :ensure_cart, :set_cart

  def index
    authorize! :read, Product
    @products = Product.order(:title)
    @tab_item = TabItem.new
  end
end
