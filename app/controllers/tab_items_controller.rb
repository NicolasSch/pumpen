class TabItemsController < ApplicationController
  def create
    tab  = current_user.tabs.tab_of_the_month
    authorize! :write, tab
    item = tab.add_or_sum_up_product(tab_item_params)
    if item.save
      respond_to do |format|
        format.js   { flash.now[:notice] = t('tab_item.create.success', title: item.product.title) }
        format.html { redirect_back fallback_location: root_path, notice: t('tab_item.create.success', title: item.product.title) }
      end
    else
      redirect_back fallback_location: root_path, alert: t('tab_item.create.alert')
    end
  end

  private

  def tab_item_params
    params.require(:tab_item).permit(:quantity, :product_id, :cart_id)
  end
end
