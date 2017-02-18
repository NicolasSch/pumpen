FactoryGirl.define do
  factory :user do
    first_name {Faker::Name.first_name }
    last_name {Faker::Name.last_name }
    gender 'male'
    email { Faker::Internet.email }
    password 'changeme'
    password_confirmation 'changeme'
    role 'user'
    confirmed_at Time.now
    
    trait :is_admin do
      role 'admin'
      email 'admin@test.com'
    end

    trait :not_admin do
      role 'user'
      email 'user@test.com'
    end
  end

end
