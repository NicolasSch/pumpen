# frozen_string_literal: true

class Admin::StatisticsController < AdminController
  include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper

  before_action :set_start, :set_end, only: :index

  def index
    products_scope = Product.sold_in_with_quantity(@start.to_datetime, @end.to_datetime)
    products_scope = products_scope.where(product_group: params[:filter]) if params[:filter].present?
    @products = smart_listing_create(:products, products_scope, partial: 'admin/statistics/sold_product', default_sort: { title: 'asc' })
  end

  def set_start
    @start ||= Time.zone.now.at_beginning_of_month - 1.month
    @start = Date.parse(params[:start]) if params[:start].present?
  end

  def set_end
    @end ||= Time.zone.now.at_end_of_month - 1.month
    @end = Date.parse(params[:end]) if params[:end].present?
  end
end
