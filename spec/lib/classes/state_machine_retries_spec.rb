# frozen_string_literal: true

RSpec.describe StateMachine do
  include_context 'with an active record model', class_name: 'Gizmo'

  class GizmoStateMachine < described_class
    TestException = Class.new(RuntimeError)

    plan do
      step :a
      step :b, expiry: 30.minutes, retries: [1.hour, 2.hours]
    end

    def before_b(_record, transition)
      expiry = states_cache[transition.effective_state.to_sym][:expiry]
      transition.expire_at = Time.now.utc + expiry
    end

    def before_b_retry_one(record, transition)
      first_attempt_at =
        record
        .transitions
        .find_by(to_state: effective_current_state)
        .created_at

      attempt_no           = transition.attempt
      delay                = states_cache[effective_current_state.to_sym][:retries][attempt_no]
      transition.expire_at = first_attempt_at + delay
    end
  end

  it 'does something' do
    model.transition_to :start
    model.transition_to :a
    model.transition_to :b
    byebug
    model.transition_to :b_retry_one
    byebug
    1
  end
end
