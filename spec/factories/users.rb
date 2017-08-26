FactoryGirl.define do
  factory :user do
    first_name {Faker::Name.first_name }
    last_name {Faker::Name.last_name }
    gender 'male'
    email { Faker::Internet.email }
    password 'changeme'
    password_confirmation 'changeme'
    role 'user'
    membership 'one'
    sequence(:member_number) { |n| n }
    confirmed_at Time.now

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
