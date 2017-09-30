# Preview all emails at http://localhost:3000/rails/mailers/notification
class NotificationPreview < ActionMailer::Preview
  def tab_items_added
    NotificationMailer.tab_items_added(serializable_items, user)
  end

  def bill_added
    NotificationMailer.bill_added(bill.user)
  end

  def open_bills_reminder
    NotificationMailer.open_bills_reminder(bill.user)
  end

  def accounting_bills_summary_mail
    NotificationMailer.accounting_bills_summary_mail(nil)
  end

  private

  def user
    tab.user
  end

  def tab
    TabItem.first.tab
  end

  def bill
    Bill.first
  end

  def serializable_items
    tab.tab_items.map do |item|
      {
        title: item.product.title,
        quantity: item.quantity,
        price: item.total_price
      }
    end
  end
end
