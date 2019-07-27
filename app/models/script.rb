class Script < ApplicationRecord
  include Transitionable

  def start(_)
    puts 'Starting...'
  end

  def step_one(_)
    puts 'Step one...'
  end
end
