# frozen_string_literal: true

class TabItem < ApplicationRecord
  belongs_to :tab
  belongs_to :product
  belongs_to :cart
  has_one :user, through: :tab

  validates :product, presence: true
  validates :quantity, numericality: { greater_than: 0 }

  def total_price
    product.price * quantity
  end
end
