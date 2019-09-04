# frozen_string_literal: true

FactoryBot.define do
  trait :schedule do
    association :participant
    name        { Faker::Lorem.words(3).join }
  end

  factory :yearly, class: Yearly, traits: %i[schedule] do
  end
end
