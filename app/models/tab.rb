class Tab < ActiveRecord::Base
  has_many :tab_items, dependent: :destroy
  belongs_to :user
  has_one :bill
  has_many :products, through: :tab_items

  before_create :set_staff_discount

  def self.tab_of_the_month
    where(month: Time.now.month).first_or_create
  end

  def total_price
    sum = tab_items.to_a.sum { |tab_item| tab_item.total_price }.to_f
    discount.present? ? sum * (100 - discount).to_f / 100 : sum
  end

  def add_or_sum_up_product(item)
    existing_item = self.tab_items.where(product_id: item[:product_id]).first
    if existing_item.present?
      existing_item.quantity += item[:quantity].to_i
      existing_item
    else
      new_item = self.tab_items.build(item)
    end
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

  def queue_items_added_mail(serializable_items)
    NotificationMailer.tab_items_added(serializable_items, self.user).deliver_later
  end

  private

  def set_staff_discount
    self.discount = 25 if user.staff_member?
  end
end
