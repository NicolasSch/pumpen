class ProductsController < ApplicationController
  include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper

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
end
