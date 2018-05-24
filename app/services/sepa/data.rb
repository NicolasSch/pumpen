module Sepa
  class Data
    include ActiveModel::Model
    include ActiveModelAttributes
    
    attribute :creditor_name, :string, default: 'Hamburg Elite Fitness GmbH'
    attribute :creditor_bic, :string, default: 'DEUTDEHHXXX'
    attribute :creditor_iban, :string, default: 'DE22200700000086488400'
    attribute :creditor_identifier, :string, default: 'DE73ZZZ00001328913'

    attribute :name,:string
    attribute :bic, :string
    attribute :iban, :string
    attribute :amount, :decimal
    attribute :currency, :string, default: 'EUR'
    attribute :reference, :string #end-to-end identification (membership number)
    attribute :usage, :string # Verwendungszweck
    attribute :mandate_id, :string
    attribute :mandate_date_of_signature, :date
    attribute :local_instrument, :string, default: 'CORE'
    attribute :sequence_type, :string, default: 'FRST'
    attribute :requested_date, :date, default: -> { Date.today.at_beginning_of_month.next_month }

    def creditor_attributes
      {
        name: creditor_name,
        bic: creditor_bic,
        iban: creditor_iban,
        creditor_identifier: creditor_identifier
      }
    end

    def debitor_attributes
      {
        name: name,
        bic: bic,
        iban: iban,
        amount: amount,
        currency: currency,
        reference: reference,
        remittance_information: usage,
        mandate_id: mandate_id,
        mandate_date_of_signature: mandate_date_of_signature,
        local_instrument: local_instrument,
        sequence_type: sequence_type,
        requested_date: requested_date,
      }
    end
  end
end