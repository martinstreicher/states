# frozen_string_literal: true

class ParticipantProgram < Program
  state :active
  state :cancelled
  state :finished
  state :inactive
  state :pending, initial: true

  transition from: :active,   to: :cancelled
  transition from: :inactive, to: :cancelled
  transition from: :pending,  to: :cancelled
  transition from: :pending,  to: :active
  transition from: :active,   to: :inactive
  transition from: :inactive, to: :active
end
