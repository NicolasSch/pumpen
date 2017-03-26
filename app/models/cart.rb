class Cart < ActiveRecord::Base
  belongs_to :user
  has_many :tab_items

  def add_product(product_id)
    current_item = tab_items.find_by_product_id(product_id)
    if current_item
      current_item.quantity += 1
    else
      current_item = tab_items.build(product_id: product_id)
    end
    current_item
  end

  def add_to_current_tab
    tab = user.tabs.tab_of_the_month
    tab_items.each do |item|
      existing_item = tab.tab_items.where(product_id: item.product_id).first
      if existing_item.present?
        existing_item.quantity += item.quantity
        existing_item.save
        item.destroy!
      else
        item.update!(tab_id: tab.id, cart_id: nil)
      end
    end
    destroy!
  end

  def total_price
    tab_items.to_a.sum { |tab_item| tab_item.total_price }
  end
end
