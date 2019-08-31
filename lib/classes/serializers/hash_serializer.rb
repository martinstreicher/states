# frozen_string_literal: true

module Serializers
  class HashSerializer
    def self.dump(hash)
      hash.to_json
    end

    def self.load(hash_or_string)
      hash = hash_or_string || {}
      hash = hash.respond_to?(:keys) ? hash : JSON.parse(hash)
      hash.with_indifferent_access
    end
  end
end
