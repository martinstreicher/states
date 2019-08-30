# frozen_string_literal: true

class Script < ApplicationRecord
  include Transitionable

  belongs_to :participant, optional: false

  validates :name, presence: true

  def self.active
    joins(:transitions).merge(Transition.active)
  end

  def active?
    transitions.active.exists?
  end
end
