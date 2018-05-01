# frozen_string_literal: true

class AddAddressToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :street,         :string
    add_column :users, :zip,            :string
    add_column :users, :city,           :string
    add_column :users, :member_number,  :integer
  end
end
