# frozen_string_literal: true

FactoryBot.define do
  factory :temperature do
    temperature_celsius { Faker::Number.decimal(l_digits: 2) }
    recorded_at { Time.zone.now }
  end
end
