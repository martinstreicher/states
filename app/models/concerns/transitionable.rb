module Transitionable
  include ActiveSupport::Concerns

  extend do
    has_many :transitions, as: :transitionable

    delegate(
      :can_transition_to?,
      :current_state,
      :transition_to!,
      :transition_to,
      to: :state_machine
    )
  end

  include do
  end
end
