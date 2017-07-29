class TabsController < ApplicationController
  before_action :ensure_tab, only: :index

  def index
    authorize! :read, @tab
    @open_bills = current_user.bills.open
    @products = current_user.most_used_products.active
    @products = Product.active.order(:title) if @products.empty?
    @tab_items = @tab.tab_items.includes(:product)
  end

  def update
    tab = current_user.tabs.find(params[:id])
    authorize! :write, tab
    item = tab.add_product(params[:product_id])
    if tab.save
      redirect_to :root, notice: t('add_tab.add_product', product: item.product.title)
    else
      redirect_to :root, alert: 'Something went wrong'
    end
  end

  private

  def tab_item_params
    params.require(:tab).permit(:product_id)
  end

  def ensure_tab
    @tab = current_user.tabs.where(month: Time.now.month).first_or_create
  end
end
