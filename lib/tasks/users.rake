# frozen_string_literal: true

require 'csv'

namespace :user do
  desc 'imports sumup csv export file'

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
