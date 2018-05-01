# frozen_string_literal: true

class CreateTabs < ActiveRecord::Migration[5.0]
  def change
    create_table :tabs do |t|
      t.timestamps null: false
      t.belongs_to :user, index: true, foreign_key: true
      t.integer :month, null: false, default: Time.zone.now.month
      t.boolean :paid, null: false, default: false
    end
  end
end
