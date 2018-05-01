# frozen_string_literal: true

class AddColumnsToProduct < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :short_title, :string
    add_column :products, :product_group_id, :integer
    add_column :products, :product_group, :string
    add_column :products, :product_type, :string
    rename_column :products, :number, :plu
  end
end
