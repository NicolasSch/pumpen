class NotificationMailer < BaseMailer
  def tab_items_added(serializable_items, user)
    @user = user
    @items = serializable_items
    mail_with_defaults(to: @user.email, subject: t('mailer.tab_mailer.items_added'))
  end
end
