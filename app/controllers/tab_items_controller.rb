class TabItemsController < ApplicationController
  before_action :set_cart

  def create
    authorize! :write, TabItem
    item = @cart.add_product(tab_item_params[:product_id])
    if item.save
      redirect_to :back, notice: t('tab_item.create.success', title: item.product.title)
    else
      redirect_to :back, alert: t('tab_item.create.alert')
    end
  end

  private

  def tab_item_params
    params.require(:tab_item)
  end
end
