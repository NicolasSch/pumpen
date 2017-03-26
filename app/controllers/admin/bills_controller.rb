class Admin::BillsController < AdminController

  def index
    @bills = Bill.order(:created_at)
  end

  def create
    tabs =  Tab.where('month < ? AND state = ?', Time.now.month, 'open')
    tabs.each do |tab|
      tab.create_bill()
    end
    redirect_to admin_bills_path, notice: t('admin.bills.notice.created')
  end

  def show
    @bill = Bill.find(params[:id])
    respond_to do |format|
      format.pdf do
        render pdf: @bill.number, layout: 'pdf.html.erb'
      end
    end
  end
end
