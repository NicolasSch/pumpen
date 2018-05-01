# frozen_string_literal: true

class Admin::TabItemsController < AdminController
  def create
    @cart = Cart.find(tab_item_params[:cart_id])
    authorize! :write, @cart
    item = @cart.add_product(tab_item_params)
    if item.save
      respond_to do |format|
        format.js { flash.now[:notice] = t('.success', title: item.product.title) }
      end
    else
      redirect_back fallback_location: root_path, alert: t('.alert')
    end
  end

  def update
    tab_item = TabItem.find(params[:id])
    authorize! :write, tab_item
    tab_item.update(tab_item_params)
    if tab_item.save
      redirect_back fallback_location: root_path, notice: t('tab_item.notice.save')
    else
      redirect_back fallback_location: root_path, alert: t('alert')
    end
  end

  def destroy
    tab_item = TabItem.find(params[:id])
    authorize! :write, tab_item
    tab_item.destroy!
    redirect_back fallback_location: root_path, notice: t('.success')
  end

  private

  def tab_item_params
    params.require(:tab_item).permit(:quantity, :product_id, :cart_id)
  end
end
