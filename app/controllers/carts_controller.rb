class CartsController < ApplicationController
  def update
    cart = Cart.find(params[:id])
    authorize! :write, cart
    cart.add_to_current_tab
    redirect_to products_path, notice: 'Added cart to users tab.'
  end
end
