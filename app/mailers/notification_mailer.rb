class NotificationMailer < BaseMailer
  def tab_items_added(serializable_items, user)
    @user = user
    @items = serializable_items
    mail_with_defaults(to: @user.email, subject: t('mailer.tab_mailer.items_added'))
  end

  def bill_added(user)
    @user = user
    mail_with_defaults(to: @user.email, subject: t('mailer.tab_mailer.bill_added'))
  end

  def open_bills_reminder(user)
    @user = user
    mail_with_defaults(to: @user.email, subject: t('mailer.tab_mailer.bill_added_reminder'))
  end
end
