# frozen_string_literal: true

class AddSerializedItemsToBills < ActiveRecord::Migration[5.0]
  def change
    add_column :bills, :items, :text
    add_column :bills, :discount, :integer
  end
end
