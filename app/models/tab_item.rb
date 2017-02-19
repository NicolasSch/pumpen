class TabItem < ActiveRecord::Base
  belongs_to :tab
  belongs_to :product
end
