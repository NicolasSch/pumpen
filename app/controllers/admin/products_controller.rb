class Admin::ProductsController < AdminController
  def index
    @filterrific = initialize_filterrific(
      Product,
      params[:filterrific]
    ) or return
    @products = @filterrific.find.page(params[:page])
  end

  def new
    @product =  Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to admin_products_path, notice: t('admin.products.notice.create')
    else
      render :new
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      redirect_to admin_products_path, notice: t('admin.products.notice.update')
    else
      render :new
    end
  end

  def destroy
    product = Product.find(params[:id])
    if product.destroy!
      redirect_to admin_products_path, notice: t('admin.products.notice.destroy')
    else
      redirect_to admin_products_path, alter: t('admin.products.destroy_error')
    end
  end

  private

  def show_archived?
    params['archived'] == 'true'
  end

  def product_params
    params.require(:product).permit(
      :title,
      :price,
      :plu,
      :product_group,
      :product_group_id,
      :product_type,
      :archived
    )
  end
end
