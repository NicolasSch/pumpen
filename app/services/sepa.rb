module Sepa
  def self.export_xml(invoices)
    debit = SEPA::DirectDebit.new(invoices.first.to_sepa_data.creditor_attributes)
    invoices.each do |invoice|
      debit.add_transaction(invoice.to_sepa_data.debitor_attributes)  
    end
    File.open('tmp/sepaso.xml', 'w') { |file| file.write(debit.to_xml) }
    invoices.update_all(exported: true)
  end
end