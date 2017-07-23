class Product < ActiveRecord::Base
  has_many :tab_items, dependent: :destroy
  validates :price, :title, presence: true
  validates :title, uniqueness: true

  scope :active,    -> { where(archived: false) }
  scope :archived,  -> { where(archived: true) }
end
