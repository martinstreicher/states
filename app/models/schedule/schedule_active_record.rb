# frozen_string_literal: true

class Schedule < ApplicationRecord
  belongs_to :scheduleable, polymorphic: true

  validates :name,         presence: true
  validates :scheduleable, presence: true
end
