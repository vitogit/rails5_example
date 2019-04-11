# spec/factories/payment_account.rb
FactoryBot.define do
  factory :payment_account do
    balance { Faker::Number.between(1, 1000) }
    external_balance { Faker::Number.between(1, 1000) }
    user_id { nil }
  end
end