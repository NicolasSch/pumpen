class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.timestamps null: false
      t.string :title
      t.decimal :price, null: false, precision: 8, scale: 2
    end
  end
end
