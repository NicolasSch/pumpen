# frozen_string_literal: true

class Api::RemindersController < ApiController
  def create
    bills = Bill.where(paid: false)
    bills.each do |bill|
      bill.user.queue_open_bills_reminder
      bill.update!(reminded_at: Time.zone.now)
    end
    head :ok
  end
end
