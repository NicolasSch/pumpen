class ProductsController < ApplicationController
  def index
    authorize! :read, Product
    @products = Product.order(:title)
    @tab_item = TabItem.new
  end
end
