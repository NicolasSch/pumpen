class Api::RemindersController < ApiController
  def create
    bills = Bill.where(paid: false)
    puts 'waaaaaaa'
    puts bills.count
    bills.each do |bill|
      bill.user.queue_open_bills_reminder
      bill.update!(reminded_at: Time.now)
    end
    head :ok
  end
end
