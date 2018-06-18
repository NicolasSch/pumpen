class ChangeAmountMembershipInvoicesColumn < ActiveRecord::Migration[5.2]
  def change
    change_column :membership_invoices, :amount, :decimal, precision: 8, scale: 2
  end
end
