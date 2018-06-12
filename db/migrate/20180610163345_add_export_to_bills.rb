class AddExportToBills < ActiveRecord::Migration[5.2]
  def up
    add_column :bills, :exported, :boolean, default: false
    bills = Bill.where('created_at < ?', '1-6-2018'.to_date.to_datetime)
    bills.update(exported: true)
  end

  def down
    remove_column :bills, :exported
  end
end
