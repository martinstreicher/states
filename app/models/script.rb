# frozen_string_literal: true

class Script < ApplicationRecord
  include Transitionable

  belongs_to :participant, optional: false

  def start(_)
    logger.info 'Starting...'
  end

  def step_one(_)
    logger.info 'Step one...'
  end
end
