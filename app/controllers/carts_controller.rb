class CartsController < ApplicationController
  def update
    cart = Cart.find(params[:id])
    authorize! :write, cart
    cart.add_to_users_current_tab
    redirect_to products_path, notice: t('cart.notice.buy')
  end

  def destroy
    cart = Cart.find(params[:id])
    authorize! :write, cart
    cart.cart_items.destroy_all
    redirect_to products_path, notice: t('cart.notice.clear')
  end
end
