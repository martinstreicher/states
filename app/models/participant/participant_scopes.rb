# frozen_string_literal: true

class Participant < ApplicationRecord
  def self.active
    where active: true
  end

  def self.by_id_or_uuid(identifier)
    where(id: identifier)
      .or(where(uuid: identifier))
      .first
  end
end
