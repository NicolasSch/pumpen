class Product < ActiveRecord::Base
  has_many :tab_items, dependent: :destroy
  validates :price, :title, presence: true
  validates :title, uniqueness: true

  default_scope { where(archived: false) }
end
