class ScriptStateMachine < StateMachine
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
