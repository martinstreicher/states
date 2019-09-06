# frozen_string_literal: true

class Hourly < Schedule
  def occurred?
    hours.include?(hour)
  end
end
