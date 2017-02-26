class CreateCarts < ActiveRecord::Migration[5.0]
  def change
    create_table :carts do |t|
      t.belongs_to :user, null: false, index: true
    end
    add_reference :tab_items, :cart, index: true
  end
end
