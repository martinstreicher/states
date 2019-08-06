# frozen_string_literal: true

class ScriptStateMachine < StateMachine
  # steps :one, two: %i[three four]
  plan do
    step :one, retries: [10.minutes, 20.minutes]
    step :two
  end

  plan do
    step :three
    step :four
  end

  def after_one
    logger.info 'After one'
  end

  def before_one
    logger.info 'Before one'
  end
end
