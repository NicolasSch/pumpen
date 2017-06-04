FactoryGirl.define do
  factory :bill do
    tab
    sequence :number {|n| "rg-#{n}"}
    paid false
  end
end
