# frozen_string_literal: true

class Product < ApplicationRecord
  has_many :tab_items, dependent: :destroy
  has_many :tabs, through: :tab_items
  validates :price, :title, presence: true
  validates :title, uniqueness: true

  scope :active,    -> { where(archived: false) }
  scope :archived,  -> { where(archived: true) }
  scope :sold_in_with_quantity, ->(start_time, end_time) do
    joins(:tab_items)
      .where('tab_items.created_at >  ? AND tab_items.created_at < ? AND tab_id IS NOT NULL', start_time, end_time)
      .select(
        'products.id, plu, title, product_group, product_group_id, product_type, SUM(quantity) AS sum_quantity,
        (price * SUM(quantity)) AS sum_price'
      )
      .group('tab_items.product_id')
  end
end
