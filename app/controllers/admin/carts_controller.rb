class Admin::CartsController < AdminController
  def new
    if cart_params[:user_id].present?
      cart = Cart.where(cart_params).first_or_create(cart_params)
      redirect_to admin_shops_path(cart_id: cart.id)
    else
      redirect_to admin_shops_path
    end
  end

  def update
    cart = Cart.find(params[:id])
    serializable_items = cart.cart_items.map do |item|
      {
        title:        item.product.title,
        quantity:     item.quantity,
        price:        item.total_price.to_f
      }
    end
    tab = cart.add_to_users_current_tab
    if tab
      tab.queue_items_added_mail(serializable_items) if tab
      redirect_to admin_shops_path(cart_id: cart.id), notice: t('cart.notice.buy')
    else
      redirect_to admin_shops_path(cart_id: cart.id), alert: t('cart.alert.buy')
    end
  end

  def destroy
    cart = Cart.find(params[:id])
    cart.cart_items.destroy_all
    redirect_to admin_shops_path(cart_id: cart.id), notice: t('cart.notice.clear')
  end

  private

  def cart_params
    params.require(:cart).permit(:user_id)
  end
end
