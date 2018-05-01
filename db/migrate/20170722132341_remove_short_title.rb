# frozen_string_literal: true

class RemoveShortTitle < ActiveRecord::Migration[5.0]
  def change
    remove_column :products, :short_title
  end
end
