class AddDiscountToTabs < ActiveRecord::Migration[5.0]
  def change
    add_column :tabs, :discount, :integer
  end
end
