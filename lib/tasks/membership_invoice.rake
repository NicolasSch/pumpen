# frozen_string_literal: true

require 'csv'

namespace :membership_invoice do
  desc 'imports sumup csv export file'

  task import_members: :environment do
    file = 'db/data/sapaso.csv'
    MembershipInvoice.transaction do
      CSV.foreach(file, headers: true) do |row|
        next unless row['IBAN']
        invoice = MembershipInvoice.new(
          firstname:row['First Name'],
          lastname: row['Last Name'],
          mandate_id: row['mandat ID'],
          membership_number: row['Member#'],
          date_of_signature: row['Date Signed'],
          address: row['Address'],
          zip: row['Postal code / City'],
          email: row['Email'],
          bank: row['Bank'],
          bic: row['BIC'],
          iban: row['IBAN'],
          amount: row['June 2018'],
          invoice_number: row['Invoice No.'],
          date_of_collection: row['Date of collection'],
          sequence_type: row['SEPA TRANSACTION']
        )
        next if MembershipInvoice.find_by(invoice_number: invoice.invoice_number)

        if invoice.save
          puts "Line #{$INPUT_LINE_NUMBER} - Invoice added:#{row['First Name']} #{row['Member#']}"
        else
          puts "#{invoice.errors.full_messages.join(', ')} for #{invoice.full_name}"
        end
      end
    end
  end

  task import_staff: :environment do
    file = 'db/data/staff.csv'
    MembershipInvoice.transaction do
      CSV.foreach(file, headers: true) do |row|
        next unless row['IBAN']
        invoice = MembershipInvoice.new(
          firstname:row['First Name'],
          lastname: row['Last Name'],
          mandate_id: row['Mandat ID'],
          membership_number: row['Personal No.'],
          date_of_signature: row['Date Signed'],
          address: row['Address'],
          zip: row['Postal code / City'],
          email: row['Email'],
          bank: row['Bank'],
          bic: row['BIC'],
          iban: row['IBAN'],
          amount: 180
        )
        next if MembershipInvoice.find_by(invoice_number: invoice.invoice_number)

        if invoice.save
          puts "Line #{$INPUT_LINE_NUMBER} - Invoice added:#{row['First Name']} #{row['Member#']}"
        else
          puts "#{invoice.errors.full_messages.join(', ')} for #{invoice.full_name}"
        end
      end
    end
  end
end
