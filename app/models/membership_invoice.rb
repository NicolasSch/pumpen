class MembershipInvoice < ApplicationRecord
  validates :firstname, :lastname, :membership_number, :date_of_collection, :date_of_signature,
    :amount, :email, :bank, :iban, :invoice_number, :mandate_id, presence: true

  validates_with SEPA::IBANValidator, field_name: :iban
  validates_with SEPA::BICValidator, field_name: :bic

  before_validation :set_invoice_number, :set_date_of_collection

  scope :unexported, -> { where(exported: false) }

  def to_sepa_data
    Sepa::Data.new(
      name: full_name,
      bic: bic,
      iban: iban,
      amount: amount,
      reference: membership_number,
      usage: invoice_number,
      mandate_id: mandate_id,
      mandate_date_of_signature: date_of_signature,
      requested_date: date_of_collection,
      sequence_type: sequence_type
    )
  end

  def full_name
    "#{firstname} #{lastname}"
  end

  private

  def set_invoice_number
    return if invoice_number.present?
    self.invoice_number = "#{membership_number}-#{Date.today.at_beginning_of_month.next_month}"
  end

  def set_date_of_collection
    return if date_of_collection.present?
    self.date_of_collection = Date.today.at_beginning_of_month.next_month
  end
end