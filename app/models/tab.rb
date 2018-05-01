# frozen_string_literal: true

class Tab < ApplicationRecord
  has_many :tab_items, dependent: :destroy
  belongs_to :user
  has_one :bill, dependent: :nullify
  has_many :products, through: :tab_items

  before_create :set_staff_discount

  scope :ready_for_billing, -> do
    where('created_at < ? AND state = ?', Time.zone.now.beginning_of_month, 'open')
  end

  def self.tab_of_the_month
    where(month: Time.zone.now.month).first_or_create
  end

  def total_price
    sum = tab_items.to_a.sum(&:total_price).to_f
    discount.present? ? sum * (100 - discount).to_f / 100 : sum
  end

  def add_or_sum_up_product(item)
    existing_item = tab_items.find_by(product_id: item[:product_id])
    if existing_item.present?
      existing_item.quantity += item[:quantity].to_i
      existing_item
    else
      tab_items.build(item)
    end
  end

  def add_product(product_id)
    current_item = tab_items.find_by(product_id: product_id)
    if current_item
      current_item.update!(quantity: current_item.quantity + 1)
    else
      current_item = tab_items.build(product_id: product_id)
    end
    current_item
  end

  def queue_items_added_mail(serializable_items)
    NotificationMailer.tab_items_added(serializable_items, user).deliver_later
  end

  private

  def set_staff_discount
    self.discount = 25 if user.staff_member?
  end
end
