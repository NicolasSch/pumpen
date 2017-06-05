class Admin::BillsController < AdminController
  def index
    unbilled_tabs   = Tab.where('month < ? AND state = ?', Time.now.month, 'open')
    @unbilled_tabs  = unbilled_tabs.select { |tab| tab.tab_items.any? }
    @filter         = filter_param.nil? ? 'all' : filter_param
    @bills          = case @filter
                      when 'all'
                        Bill.order(created_at: :desc)
                      when 'paid'
                        Bill.where(paid: true).order(created_at: :desc)
                      when 'open'
                        Bill.where(paid: false).order(created_at: :desc)
                      end
  end

  def create
    tabs =  Tab.where('month < ? AND state = ?', Time.now.month, 'open')
    tabs.each do |tab|
      if tab.tab_items.any?
        tab.create_bill(
          amount: tab.total_price,
          items: BillPresenter.serialized_items(tab.tab_items),
          discount: tab.discount
        )
        tab.state = 'billed'
        tab.save
      else
        tab.destroy!
      end
    end
    redirect_to admin_bills_path, notice: t('admin.bills.notice.created')
  end

  def show
    bill = Bill.joins(:tab).find(params[:id])
    @bill_presenter = BillPresenter.new(bill, view_context)
    respond_to do |format|
      format.pdf do
        render pdf: @bill_presenter.number,
               layout: 'pdf.html.erb',
               disposition: 'inline',
               orientation: 'Portrait',
               page_size: 'A4',
               dpi: 300
      end
    end
  end

  def update
    bill = Bill.find(params[:id])
    bill.paid = true
    if bill.save
      bill.tab.update!(state: 'closed')
      redirect_to admin_bills_path, notice: t('admin.bills.notice.paid')
    else
      redirect_to admin_bills_path, alert: t('admin.notice.alert')
    end
  end

  private

  def filter_param
    params.dig(:bill, :filter, :term)
  end
end
