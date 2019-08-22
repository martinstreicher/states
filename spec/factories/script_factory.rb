# frozen_string_literal: true

FactoryBot.define do
  factory :script do
    association :participant
    name        { 'xyz' }
  end
end
