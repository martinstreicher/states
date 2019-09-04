# frozen_string_literal: true

class Participant < ApplicationRecord
  has_many :schedules, dependent: :destroy, as: :scheduleable
  has_many :scripts,   dependent: :destroy, inverse_of: :participant

  validates :name, presence: true
end
