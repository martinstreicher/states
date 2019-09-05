# frozen_string_literal: true

class Weekly < Schedule
  def occurred?
    weeks.include?(week)
  end
end
