class Admin::ShopsController < AdminController
  def index
    @users     = User.order(:last_name)
    @products = Product.order(:title)
    @tab_item = TabItem.new
    @tab      = Tab.new
  end
end
