class AddProductNumberToProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :product_number, :string
  end
end
