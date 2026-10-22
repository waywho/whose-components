# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email_address) { "user#{it}@example.com" }
    password { "password123" }
  end
end
