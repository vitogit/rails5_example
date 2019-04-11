# spec/factories/payments.rb
FactoryBot.define do
  factory :payment do
    amount { Faker::Number.between(1, 100) }
    description { Faker::Lorem.word }
    sender_id { nil }
    receiver_id { nil }
  end
end