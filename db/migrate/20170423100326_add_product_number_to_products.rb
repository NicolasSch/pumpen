# frozen_string_literal: true

class AddProductNumberToProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :number, :string
  end
end
