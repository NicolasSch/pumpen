FactoryBot.define do
  factory :bill do
    tab
    sequence(:number) { |n| "rg-#{n}" }
    amount { tab.total_price }
    paid false
  end
end
