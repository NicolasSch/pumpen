FactoryGirl.define do
  factory :tab do
    user
    month Time.now.month
  end

  trait :with_tab_item do
    after(:create) do |tab|
      create(:tab_item, tab: tab)
    end
  end
end
