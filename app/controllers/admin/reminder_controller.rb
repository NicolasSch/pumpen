class Admin::ReminderController < AdminController
  def show
    user = Bill.find(params[:bill_id]).user
    user.queue_open_bills_reminder
    redirect_back fallback_location: root_path, notice: t('admin.reminder.notice')
  end
end
