FactoryGirl.define do
  factory :product do
    title { Faker::Beer.name }
    price { rand(1.0..200.0) }
  end
end
