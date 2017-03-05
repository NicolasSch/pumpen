class Admin::ShopsController < AdminController
  before_action :set_cart, only: :index

  def index
    @users    = User.order(:last_name)
    @products = Product.order(:title)
    @tab_item = TabItem.new
  end

  private

  def set_cart
    @cart = params[:cart_id].present? ? Cart.where(id: params[:cart_id]).first! : Cart.new
  end
end
