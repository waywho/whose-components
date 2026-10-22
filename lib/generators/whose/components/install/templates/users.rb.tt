# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { "Ann" }
    last_name { "Lee" }
    sequence(:email_address) { "user#{it}@example.com" }
    password { "password123" }
    confirmed_at { Time.current }

    trait :unconfirmed do
      confirmed_at { nil }
    end
  end
end
