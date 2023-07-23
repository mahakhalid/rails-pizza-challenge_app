FactoryBot.define do
  factory :order do
    state { false }
    items { [{name: 'Salami', size: 'Medium', add: ['Onions', remove: ['Cheese']]}] }
    promotion_codes { [] }
    discount_code { nil }
  end
end