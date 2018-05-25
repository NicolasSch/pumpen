class AddbankDataToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :bic, :string
    add_column :users, :iban, :string
    add_column :users, :bank, :string
    add_column :users, :sepa_date_signed, :date
    add_column :users, :sepa_mandate_id, :string
  end
end
