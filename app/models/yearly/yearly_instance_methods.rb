# frozen_string_literal: true

class Yearly < Schedule
  def occurred?
    years.include?(year)
  end
end
