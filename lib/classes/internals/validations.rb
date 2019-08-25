# frozen_string_literal: true

module Internals
  module Validations
    def validate(options, instruction)
      options.extend ActiveModel::Validations
      validator = "#{method(instruction).owner}Internals".safe_constantize
      validator&.validate(options)
    end
  end
end
