# frozen_string_literal: true

class Participant < ApplicationRecord
  serialize :history, Serializers::HashSerializer

  has_many :scripts, dependent: :destroy, inverse_of: :participant

  validates :name, presence: true

  def self.active
    where active: true
  end

  def self.by_id_or_uuid(identifier)
    where(id: identifier)
      .or(where(uuid: identifier))
      .first
  end
end
