class ProductsController < ApplicationController
  include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper

  before_action :ensure_cart, :set_cart

  def index
    products_scope = params[:archived] == '1' ?  Product.archived : Product.active
    products_scope = products_scope.where(product_group: params[:filter]) if params[:filter].present?
    @products = smart_listing_create(:products, products_scope, partial: "admin/products/product", default_sort: { title: 'asc' })
  end

  def index
    authorize! :read, Product
    @tab_item      = TabItem.new
    @open_bills    = current_user.bills.open
    products_scope = Product.active
    products_scope = products_scope.where(product_group: params[:filter]) if params[:filter].present?
    @products      = smart_listing_create(:products, products_scope, partial: "/products/product", default_sort: { title: 'asc' })

  end

  private

  def ensure_cart
    Cart.create!(user: current_user) unless current_user.cart.present?
  end

  def set_cart
    @cart = current_user.cart
  end
end
