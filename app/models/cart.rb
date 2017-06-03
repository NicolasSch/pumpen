class Cart < ActiveRecord::Base
  alias_attribute :cart_items, :tab_items

  belongs_to :user
  has_many :tab_items

  def add_product(product_id)
    current_item = cart_items.find_by_product_id(product_id)
    if current_item
      current_item.quantity += 1
    else
      current_item = cart_items.build(product_id: product_id)
    end
    current_item
  end

  def add_to_users_current_tab
    tab   = user.tabs.tab_of_the_month
    cart_items.each do |item|
      existing_item = tab.tab_items.where(product_id: item.product_id).first
      if existing_item.present?
        existing_item.quantity += item.quantity
        existing_item.save
        item.destroy!
      else
        item.update!(tab_id: tab.id, cart_id: nil)
      end
    end
    tab
  end

  def total_price
    cart_items.to_a.sum { |cart_item| cart_item.total_price }
  end
end
