# frozen_string_literal: true

class AddArchivedToUsersAndProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :archived, :boolean, default: false
    add_column :users,    :archived, :boolean, default: false
  end
end
