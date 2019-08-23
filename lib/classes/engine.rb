# frozen_string_literal: true

class Engine
  def execute
    #
    # 1/ Expire scripts by changing each script's state to `expire`
    #
    # 2/ Advance each script due to transition
    #
    # 3/ Run schedulers that launch new scripts

    Script.scheduled_to_expire.find_each do |script| # (1)
      script.transition_to(:expire)
    end

    Script.scheduled_to_transition.find_each(&:retry) # (2)

    # TODO: (3)
  end
end
