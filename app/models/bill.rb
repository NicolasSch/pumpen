# frozen_string_literal: true

require 'csv'

class Bill < ApplicationRecord
  belongs_to :tab
  has_one :user, through: :tab
  has_many :products, through: :tab
  has_many :tab_items, through: :tab

  serialize :items

  before_validation :add_number, on: :create
  after_create :queue_bill_added_mail

  validates :number, presence: true

  scope :name_like, ->(name) do
    joins(:user)
      .where("(concat(first_name, ' ', last_name) like ?) OR (concat(last_name, ' ', first_name) like ?)", "%#{name}%", "%#{name}%")
  end

  scope :open, -> { where(paid: false) }

  def self.queue_accouting_bills_summary_mail(bills)
    attachment = create_bill_summary_csv(bills)
    NotificationMailer.accounting_bills_summary_mail(attachment).deliver_later
  end

  class << self
    private

    def create_bill_summary_csv(bills)
      CSV.generate(headers: true) do |csv|
        csv << csv_header
        bills.each do |bill|
          csv << csv_row(bill)
        end
      end
    end

    def csv_row(bill)
      [
        bill.tab.month,
        bill.number,
        bill.created_at.to_date,
        bill.tab.user.full_name,
        bill.tab.user.member_number,
        bill.amount,
        '19%',
        format('%.2f', (bill.amount.to_f * 0.81)),
        bill.tab.products.pluck(:title).uniq.join(',')
      ]
    end

    def csv_header
      %i[
        Monat
        Rechnungsnummer
        Rechnungsdatum
        Rechnungsempfänger
        Membershipnummer
        Nettobetrag
        MWST
        Bruttobetrag
        Artikelbezeichnungen
      ]
    end
  end

  private

  def queue_bill_added_mail
    NotificationMailer.bill_added(user).deliver_later
  end

  def add_number
    return if number.present?
    self.number = "RG-#{tab.id}-#{tab.created_at.year % 100}#{tab.month}"
  end
end
