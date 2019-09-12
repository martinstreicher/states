# frozen_string_literal: true

FactoryBot.define do
  trait :schedule do
    association :scheduleable, factory: :participant
    name        { Faker::Lorem.words(number: 3).join }
  end

  factory :hourly, class: Hourly, traits: %i[schedule] do
  end

  factory :minutely, class: Hourly, traits: %i[schedule] do
  end

  factory :monthly, class: Hourly, traits: %i[schedule] do
  end

  factory :weekly, class: Yearly, traits: %i[schedule] do
  end

  factory :yearly, class: Yearly, traits: %i[schedule] do
  end
end
