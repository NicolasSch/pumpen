class Api::RemindersController < ApiController
  def update
    bills = Bill.where(paid: false)
    bills.each do |bill|
      bill.user.queue_open_bills_reminder
      bill.update!(reminded_at: Time.now)
    end
    head :ok
  end
end
