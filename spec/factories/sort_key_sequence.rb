# frozen_string_literal: true

FactoryBot.define do
  sequence(:sort_key) { |n| n * 10 }
end
