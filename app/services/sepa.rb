module Sepa
  def self.export_xml(invoices)
    debit = SEPA::DirectDebit.new(invoices.first.to_sepa_data.creditor_attributes)
    invoices.each do |invoice|
      debit.add_transaction(invoice.to_sepa_data.debitor_attributes)  
    end
    invoices.update_all(exported: true) if invoices.first.is_a?(Bill)
    debit.to_xml
  end
end