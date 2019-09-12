# frozen_string_literal: true

FactoryBot.define do
  factory :participant do
    enrolled_at { Time.zone.now - 2.weeks }
    name        { Faker::Name.name }
    uuid        { Faker::Code.sin }
  end
end
