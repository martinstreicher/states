# frozen_string_literal: true

class Engine
  def execute
    #
    # 1/ Formally transition expiring states to `expired`

    Script.scheduled_to_expire.find_each do |script|
      script.transition_to(:expire)
    end
  end
end
