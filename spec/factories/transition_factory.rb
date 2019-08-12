# frozen_string_literal: true

FactoryBot.define do
  factory :transition do
    most_recent { false }
    sort_key
    to_state    { UUID.generate }
    association :transitionable, factory: :script

    factory :most_recent_transition do
      most_recent { true }
    end
  end
end
