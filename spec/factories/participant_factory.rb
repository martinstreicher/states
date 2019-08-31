# frozen_string_literal: true

FactoryBot.define do
  factory :participant do
    name { Faker::Name.name }
    uuid { Faker::Code.sin }
  end
end
