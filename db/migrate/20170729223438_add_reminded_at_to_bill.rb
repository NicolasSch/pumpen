class AddRemindedAtToBill < ActiveRecord::Migration[5.0]
  def change
    add_column :bills, :reminded_at, :datetime
  end
end
