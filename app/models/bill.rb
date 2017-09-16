require 'csv'

class Bill < ActiveRecord::Base
  belongs_to :tab
  has_many :tab_items, through: :tab
  before_save :add_number
  belongs_to :tab
  has_one :user, through: :tab

  has_many :products, through: :tab

  serialize :items

  after_create :queue_bill_added_mail

  scope :name_like, ->(name) { joins(:user).where("(concat(first_name, ' ', last_name) like ?) OR (concat(last_name, ' ', first_name) like ?)","%#{name}%", "%#{name}%") }
  scope :open, -> { where(paid: false) }

  def self.queue_accouting_bills_summary_mail(bills)
    attachment = create_bill_summary_csv(bills)
    NotificationMailer.accounting_bills_summary_mail(attachment).deliver_later
  end

  private

  def self.create_bill_summary_csv(bills)
    CSV.generate(headers: true) do |csv|
      csv << [:Monat,
        :Rechnungsnummer,
        :Rechnungsdatum,
        :Rechnungsempfänger,
        :Membershipnummer,
        :Nettobetrag,
        :MWST,
        :Bruttobetrag,
        :Artikelbezeichnungen
      ]

      bills.each do |bill|
        csv << [
            bill.tab.month,
            bill.number,
            bill.created_at.to_date,
            "#{bill.tab.user.first_name} #{bill.tab.user.first_name}",
            bill.tab.user.member_number,
            bill.amount,
            '19%',
            '%.2f' % (bill.amount.to_f * 0.81),
            bill.tab.products.pluck(:title).uniq.join(',')
          ]
      end
    end
  end

  def queue_bill_added_mail
    NotificationMailer.bill_added(self.user).deliver_later
  end

  def add_number
    self.number = "RG-#{self.tab.user.id}-#{Date.today.year}-#{tab.month}"
  end
end
