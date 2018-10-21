# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    gender 'male'
    email { Faker::Internet.email }
    password 'changeme'
    password_confirmation 'changeme'
    role 'user'
    membership 'one'
    street 'foo strasse 1'
    zip '21629'
    city 'Hamburg'
    sequence(:member_number) { |n| n }
    sequence(:sepa_mandate_id) { |n| n }
    sepa_date_signed { Time.zone.now.to_date }
    iban 'DE73200000000020101538'
    bic 'MARKDEF1200'
    confirmed_at { Time.zone.now }

    trait :is_admin do
      role 'admin'
      email 'admin@test.com'
    end

    trait :not_admin do
      role 'user'
    end

    trait :is_manager do
      role 'user'
      membership 'staff'
    end
  end
end
