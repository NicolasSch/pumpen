class Admin::ShopsController < AdminController
  include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper

  before_action :set_cart, only: :index

  def index
    @users    = User.order(:last_name)
    products_scope = Product.active
    products_scope = products_scope.where(product_group: params[:filter]) if params[:filter].present?
    @products      = smart_listing_create(:products, products_scope, partial: "/admin/shops/products/products_list", default_sort: { title: 'asc' })
    @tab_item = TabItem.new
    @tab = @cart.user.tabs.tab_of_the_month if @cart.user.present?
  end

  private

  def set_cart
    @cart = params[:cart_id].present? ? Cart.where(id: params[:cart_id]).first! : Cart.new
  end
end
