# frozen_string_literal: true

class Api::BillsController < ApiController
  def create
    tabs = Tab.ready_for_billing
    bills_for_accounting = []
    tabs.each do |tab|
      if tab.tab_items.any?
        bills_for_accounting.push(
          tab.create_bill(
            amount: tab.total_price,
            items: BillPresenter.serialized_items(tab.tab_items),
            discount: tab.discount
          )
        )
        tab.state = 'billed'
        tab.save
      else
        tab.destroy!
      end
    end
    Bill.queue_accouting_bills_summary_mail(bills_for_accounting)
    head 201
  end
end
