class Admin::BillsController < AdminController
  def index
    @unbilled_tabs = Tab.left_outer_joins(:bill).where('tab_id is NULL')
    @bills = Bill.where(paid: false)
  end

  def create
    tabs =  Tab.where('month < ? AND state = ?', Time.now.month, 'open')
    tabs.each do |tab|
      tab.create_bill
      tab.state = 'billed'
      tab.save
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

  def update
    bill = Bill.find(params[:id])
    bill.paid = true
    if bill.save
      redirect_to admin_bills_path, notice: t('admin.bills.paid')
    else
      redirect_to admin_bills_path, alert: t('admin.alert')
    end
  end
end
