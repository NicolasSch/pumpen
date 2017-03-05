class CartsController < AdminController
  def update
    cart = Cart.find(params[:id])
    cart.add_to_current_tab
    redirect_to products_path, notice: 'Added cart to users tab.'
  end
end
