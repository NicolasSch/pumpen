class Tab < ActiveRecord::Base
  has_many :tab_items
  belongs_to :user
end
