# frozen_string_literal: true

module Implementations
  class Base
    delegate :participant, to: :record
    delegate :group, to: :participant
    delegate :study, to: :group

    def self.perform(options, record, transition)
      struct = RecursiveOpenStruct.new options
      new(struct, record, transition).perform
    end

    def initialize(options, record, transition)
      @options    = options
      @record     = record
      @transition = transition
    end

    def perform; end

    private

    attr_reader :options, :record, :transitions
  end
end
