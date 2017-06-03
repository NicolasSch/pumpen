FactoryGirl.define do
  factory :product do
    sequence(:title) { |n| "#{Faker::Beer.name}_#{n}" }
    price { rand(1.0..200.0) }
  end
end
