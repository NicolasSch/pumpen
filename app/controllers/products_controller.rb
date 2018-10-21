# frozen_string_literal: true

class ProductsController < ApplicationController
  include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper

  def index
    redirect_to root_path unless current_user.tab_manager?
    authorize! :read, Product
    @tab_item      = TabItem.new
    @open_bills    = current_user.bills.open
    products_scope = Product.active
    products_scope = products_scope.where(product_group: params[:filter]) if params[:filter].present?
    @products      = smart_listing_create(:products, products_scope, partial: '/products/product', default_sort: { title: 'asc' })
  end
end
