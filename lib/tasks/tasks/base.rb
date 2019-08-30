# frozen_string_literal: true

module Tasks
  class Base
    include Rake::DSL

    def each_participant(scope: Participant.active)
      return enum_for(:each_participant) unless block_given?

      scope.find_each { |participant| yield participant }
    end
  end
end
