class CreateMembershipInvoices < ActiveRecord::Migration[5.2]
  def change
    create_table :membership_invoices do |t|
      t.string :firstname
      t.string :lastname
      t.string :membership_number
      t.date :date_of_signature
      t.string :address
      t.string :zip
      t.string :email
      t.string :bank
      t.string :bic
      t.string :iban
      t.decimal :amount
      t.date :date_of_collection
      t.string :invoice_number
      t.string :sequence_type
    end
  end
end
