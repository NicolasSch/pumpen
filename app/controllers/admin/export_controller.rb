class Admin::ExportController < AdminController
  def index
    start_time  = Time.new(date_params[:year],date_params[:month])
    end_time    = Time.new(date_params[:year],date_params[:month]) + 1.month
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
