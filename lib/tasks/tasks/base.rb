# frozen_string_literal: true

module Tasks
  class Base
    include Rake::DSL

    def each_participant(scope: Participant.active)
      return enum_for(:each_participant) unless block_given?

      scope.find_each { |participant| yield participant }
    end

    def find_participant(identifier_or_model)
      return identifier_or_model if identifier_or_model.respond_to?(:name)

      Participant.by_id_or_uuid(identifier_or_model)
    end
  end
end
