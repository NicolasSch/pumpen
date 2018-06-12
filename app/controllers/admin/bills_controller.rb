# frozen_string_literal: true

class Admin::BillsController < AdminController
  include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper

  def index
    bills_scope = params[:paid].present? ? Bill.where(paid: params[:paid] == '1') : Bill.all
    bills_scope = bills_scope.name_like(params[:filter]) if params[:filter].present?
    @bills = smart_listing_create(
      :bills,
      bills_scope.includes(:tab, :user),
      partial: 'admin/bills/bill',
      default_sort: { 'bills.created_at' => :desc }
    )
    unbilled_tabs   = Tab.ready_for_billing.includes(:tab_items)
    @unbilled_tabs  = unbilled_tabs.select { |tab| tab.tab_items.any? }
  end

  def create
    tabs = Tab.ready_for_billing
    bills_for_accounting = []
    tabs.each do |tab|
      if tab.tab_items.any?
        bills_for_accounting.push(
          tab.create_bill!(
            amount: tab.total_price,
            items: BillPresenter.serialized_items(tab.tab_items),
            discount: tab.discount
          )
        )
        tab.state = 'billed'
        tab.save!
      else
        tab.destroy!
      end
    end
    Bill.queue_accouting_bills_summary_mail(bills_for_accounting)
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
