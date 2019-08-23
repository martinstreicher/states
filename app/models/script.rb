# frozen_string_literal: true

class Script < ApplicationRecord
  include Transitionable

  belongs_to :participant, optional: false

  validates :name, presence: true
end
