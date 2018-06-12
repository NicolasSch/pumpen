class AddCityToMemberships < ActiveRecord::Migration[5.2]
  def change
    add_column :membership_invoices, :city, :string
  end
end
