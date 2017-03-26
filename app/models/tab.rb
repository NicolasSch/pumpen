class Tab < ActiveRecord::Base
  has_many :tab_items, dependent: :destroy
  belongs_to :user
  has_one :bill

  def self.tab_of_the_month
    where(month: Time.now.month).first_or_create
  end

  def total_price
    tab_items.to_a.sum { |tab_item| tab_item.total_price }
  end

  def add_product(product_id)
    current_item = tab_items.find_by_product_id(product_id)
    if current_item
      current_item.update!(quantity: current_item.quantity + 1)
    else
      current_item = tab_items.build(product_id: product_id)
    end
    current_item
  end

  def add_tab_items_from_cart(cart)
    cart.line_items.each do |item|
      current_item = tab_items.find_by_product_id(item.product_id)
      if current_item
        current_item.quantity += item.quantity
        item.destroy!
      else
        item.cart_id = nil
        tab_items << item
      end
    end
  end
end
