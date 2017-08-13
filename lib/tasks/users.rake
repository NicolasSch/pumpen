require 'csv'

namespace :user do
  desc "imports sumup csv export file"

  task import: :environment do
    file = 'db/data/users.csv'
    CSV.foreach(file, :headers => true) do |row|
      user = User.where(email: row['Email']).first
      unless user
        user = User.create!(
          last_name:  row['Last Name'],
          first_name: row['First Name'],
          email:      row['Email'],
          password:   'changeme',
          membership: 'one',
        )
        puts "Line #{$.} - Benutzer: #{row['Email']} created"
      else
        user.update!(
          last_name:  row['Last Name'],
          first_name: row['First Name'],
          email:      row['Email'],
        )
        puts "Line #{$.} - Benutzer: #{row['Email']} updated"
      end
    end
  end
end
