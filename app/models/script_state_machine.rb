class ScriptStateMachine < StateMachine
  state :step_one
  transition from: :start, to: :step_one

  before_transition(to: :step_one) do |record, transition|
    record.step_one transition
  end

  # steps :one, two: %i[three four]
  plan do
    step :one
    step :two
  end

  plan do
    step :three
    step :four
  end
end
