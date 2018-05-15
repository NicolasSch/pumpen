module Xml
  class TabInvoiceData
    include ActiveModel::Model
    include ActiveModelAttributes
    
    attribute :membership_number, :string
    attribute :amount, :decimal
    attribute :full_name, :string
    attribute :bic, :string
    attribute :iban, :string
    attribute :invoice_date
    attribute :date_of_signature, :date, default: -> { Time.zone.today }
    attribute :mndt_id, :string, default: 'SFI'
    attribute :amdmnt_id, :string, default: false

    def description
      raise InvoiceDateNotProvidedError unless invoice_date.present?
      raise AmountNotProvidedError unless amount.present?
      "Tabrechnung #{invoice_date} Hamburg Elite Fitness Gmbh : #{amount}"
    end

    class InvoiceDateNotProvidedError < StandardError; end
    class AmountNotProvidedError < StandardError; end
  end
end