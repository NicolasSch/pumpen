class MakeMemberNumberAString < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :member_number, :string
  end
end
