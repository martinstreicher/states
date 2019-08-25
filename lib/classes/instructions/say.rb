# frozen_string_literal: true

module Instructions
  module Say
    DEFAULT_OPTIONS = {
      kind: :sms
    }.freeze

    def say(message, options = {})
      options = options.symbolize_keys.merge(message: message)
      options = options.reverse_merge DEFAULT_OPTIONS
      validate options, __method__

      state_name = options[:id]
      state_name ||= "say_#{states_cache.size}"
      self.states_cache = states_cache.merge state_name => options

      instance_eval do
        state state_name
      end
    end
  end

  module SayInternals
    KINDS = %i[email sms].freeze

    def self.validate(options) # rubocop:disable Metrics/AbcSize
      options.extend ActiveModel::Validations

      options.errors.tap do |errors|
        symbolized_options = options.symbolize_keys

        KINDS.include?(symbolized_options[:kind]&.to_sym) ||
          errors.add(:kind, "must be one of #{KINDS.join(', ')}")

        symbolized_options[:message].presence ||
          errors.add(:message, 'cannot be blank')
      end

      return if options.errors.empty?

      message = options.errors.map { |field, error| "#{field}: #{error}" }.join('; ')
      raise ArgumentError, message
    end
  end
end
