class ScriptStateMachine < StateMachine
  state :step_one
  transition from: :started, to: :step_one

  before_transition(to: :step_one) do |record, transition|
    record.step_one transition
  end

  # states :one, :two
end
