# frozen_string_literal: true

class CreateTabItems < ActiveRecord::Migration[5.0]
  def change
    create_table :tab_items do |t|
      t.timestamps null: false
      t.belongs_to :product, index: true, foreign_key: true
      t.belongs_to :tab, index: true, foreign_key: true
      t.integer :quantity, default: 1
    end
  end
end
