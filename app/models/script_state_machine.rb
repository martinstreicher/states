class ScriptStateMachine < StateMachine
  state :pending, initial: true
  state :finished

  transition from: :pending, to: :finished
end
