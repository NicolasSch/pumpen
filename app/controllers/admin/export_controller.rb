# frozen_string_literal: true

class Admin::ExportController < AdminController
  def index
    start_time  = Date.new(date_params[:year].to_i, date_params[:month].to_i)
    end_time    = Date.new(date_params[:year].to_i, date_params[:month].to_i) + 1.month
    bills = Bill.where('created_at >= ? AND created_at < ?', start_time, end_time)
    send_data Bill.create_bill_summary_csv(bills),
              type: 'application/csv',
              filename: "#{date_params[:month]}-#{date_params[:year]}-bills.csv",
              disposition: 'attachment'
  end

  private

  def date_params
    params.require(:date).permit(:month, :year)
  end
end
