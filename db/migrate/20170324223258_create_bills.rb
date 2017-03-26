class CreateBills < ActiveRecord::Migration[5.0]
  def up
    create_table :bills do |t|
      t.timestamps null: false
      t.belongs_to :tab
      t.string :number, null: false
      t.boolean :paid, default: false
    end
    remove_column :tabs, :paid
    add_column :tabs, :state, :string, default: 'open'
  end

  def down
  end
end
