# frozen_string_literal: true

module Keywords
  module Step
    def step(*names)
      state_names = names.clone
      options     = names.last.respond_to?(:keys) ? state_names.pop : {}
      options     = options.symbolize_keys
      state_names.each { |state| self.states_cache = states_cache.merge(state => options) }

      state_names.each do |name|
        instance_eval do
          state name
        end
      end
    end
  end
end
