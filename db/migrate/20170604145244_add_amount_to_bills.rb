# frozen_string_literal: true

class AddAmountToBills < ActiveRecord::Migration[5.0]
  def change
    add_column :bills, :amount, :decimal, null: false, precision: 8, scale: 2
  end
end
