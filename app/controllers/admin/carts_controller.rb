class Admin::CartsController < AdminController
  def new
    cart = Cart.where(cart_params).first_or_create(cart_params)
    redirect_to admin_shops_path(cart_id: cart.id)
  end

  def update
    cart = Cart.find(params[:id])
    cart.add_to_current_tab
    redirect_to admin_shops_path, notice: 'Added cart to users tab.'
  end

  private

  def cart_params
    params.require(:cart).permit(:user_id)
  end
end
