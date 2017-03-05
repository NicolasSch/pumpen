class TabItem < ActiveRecord::Base
  belongs_to :tab
  belongs_to :product
  has_one :user, through: :tab

  validates :product, presence: true

  def total_price
    product.price * quantity
  end
end
