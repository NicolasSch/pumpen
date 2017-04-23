class Tab < ActiveRecord::Base
  has_many :tab_items, dependent: :destroy
  belongs_to :user
  has_one :bill

  before_create :set_staff_discount

  def self.tab_of_the_month
    where(month: Time.now.month).first_or_create
  end

  def total_price
    sum = tab_items.to_a.sum { |tab_item| tab_item.total_price }.to_f
    discount.present? ? sum * (100 - discount).to_f / 100 : sum
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

  private

  def set_staff_discount
    self.discount = 25 if user.staff_member?
  end
end
