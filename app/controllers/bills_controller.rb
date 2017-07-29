class BillsController < ApplicationController
  def index
    authorize! :read, Bill
    @open_bills = current_user.bills.open
    @bills = current_user.bills.order(created_at: :desc)
  end

  def show
    bill = current_user.bills.joins(:tab).find(params[:id])
    authorize! :download, bill
    @bill_presenter = BillPresenter.new(bill, view_context)
    respond_to do |format|
      format.pdf do
        render pdf: @bill_presenter.number,
               layout: 'pdf.html.erb',
               disposition: 'attachment',
               orientation: 'Portrait',
               page_size: 'A4',
               dpi: 300
      end
    end
  end
end
