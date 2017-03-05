class TabsController < ApplicationController
  before_action :ensure_tab, only: :index

  def index
    authorize! :read, @tab
    @products = Product.all
  end

  def update
    tab = current_user.tabs.find(params[:id])
    authorize! :write, tab
    tab.add_product(params[:product_id])
    if tab.save
      redirect_to :root
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
