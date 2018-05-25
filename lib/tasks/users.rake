# frozen_string_literal: true

require 'csv'

namespace :user do
  desc 'imports sumup csv export file'

  task import_staff: :environment do
    file = 'db/data/staff.csv'
    CSV.foreach(file, headers: true) do |row|
      next unless row['IBAN']
      user = User.find_by(email: row['Email'])
      attributes = {
          first_name:row['First Name'],
          last_name: row['Last Name'],
          sepa_mandate_id: row['Mandat ID'],
          member_number: row['Personal No.'],
          sepa_date_signed: row['Date Signed'],
          street: row['Address'].split(' ').first,
          zip: row['Postal code / City'].split(' ').first,
          city: row['Postal code / City'].split(' ').last,
          bank: row['Bank'],
          bic: row['BIC'],
          email: row['Email'],
          iban: row['IBAN'],
      }
      if user
        user.update(attributes)
      else 
        User.create!(attributes.merge(password: 'changeme'))
      end
    end
  end

  task import: :environment do
    file = 'db/data/users.csv'
    CSV.foreach(file, headers: true) do |row|
      user = User.where(email: row['Email']).first
      if user
        user.update!(
          last_name:  row['Last Name'],
          first_name: row['First Name'],
          email:      row['Email']
        )
        puts "Line #{$INPUT_LINE_NUMBER} - Benutzer: #{row['Email']} updated"
      else
        User.create!(
          last_name:  row['Last Name'],
          first_name: row['First Name'],
          email:      row['Email'],
          password:   'changeme',
          membership: 'one'
        )
        puts "Line #{$INPUT_LINE_NUMBER} - Benutzer: #{row['Email']} created"
      end
    end
  end
end
