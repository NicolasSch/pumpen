class TabItem < ActiveRecord::Base
  belongs_to :tab
  belongs_to :product

  def total_price
    product.price * quantity
  end
end
