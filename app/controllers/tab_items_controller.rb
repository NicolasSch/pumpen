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

  def update
    tab_item = TabItem.find(params[:id])
    authorize! :write, tab_item
    tab_item.update_attributes(tab_item_params)
    if tab_item.save
      redirect_to :back, notice: t('tab_item.notice.save')
    else
      redirect_to :back, alert: t('alert')
    end
  end

  def destroy
    tab_item = TabItem.find(params[:id])
    authorize! :write, tab_item
    tab_item.destroy!
    redirect_to :back, notice: t('tab_item.notice.destroy')
  end

  private

  def tab_item_params
    params.require(:tab_item).permit(:quantity, :product_id)
  end
end
