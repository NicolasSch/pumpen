# frozen_string_literal: true

class NotificationMailer < BaseMailer
  ACCOUNTING_MAIL_ADDRESS = 'M.Kutschewenko@beyer-foertsch.de'
  CFHH_MAIL_ADDRESS       = 'michael@crossfithh.de'

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

  def accounting_bills_summary_mail(attachment)
    attachments['tab_summary.csv'] = attachment
    mail_with_defaults(to: ACCOUNTING_MAIL_ADDRESS, cc: CFHH_MAIL_ADDRESS, subject: t('mailer.accounting_bills_summary_mail'))
  end
end
