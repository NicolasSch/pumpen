class Admin::ReminderController < AdminController
  def show
    bill = Bill.find(params[:bill_id])
    bill.user.queue_open_bills_reminder
    bill.update!(reminded_at: Time.now)
    redirect_back fallback_location: root_path, notice: t('admin.reminder.notice')
  end
end
