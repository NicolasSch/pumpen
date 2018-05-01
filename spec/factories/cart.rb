# frozen_string_literal: true

FactoryBot.define do
  factory :cart do
    transient do
      products { [create(:product), create(:product)] }
    end

    user { create(:user) }

    trait :with_cart_items do
      after(:create) do |cart, evaluator|
        create(:tab_item, cart_id: cart.id, product: evaluator.products[0])
        create(:tab_item, cart_id: cart.id, product: evaluator.products[1])
      end
    end
  end
end
