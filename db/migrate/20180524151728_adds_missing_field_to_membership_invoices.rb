class AddsMissingFieldToMembershipInvoices < ActiveRecord::Migration[5.2]
  def change
    add_column :membership_invoices, :mandate_id, :string
    add_column :membership_invoices, :exported, :boolean, default: false 
  end
end
