FactoryGirl.define do
  factory :tab do
    user
  end

  trait :with_item do
    after(:create) do |tab|
      create(:tab_item, tab: tab)
    end
  end
end
