# frozen_string_literal: true

FactoryBot.define do
  factory :tab do
    user { create(:user) }
    month { Time.zone.now.month }
  end

  trait :with_tab_item do
    after(:create) do |tab|
      create(:tab_item, tab: tab)
    end
  end
end
