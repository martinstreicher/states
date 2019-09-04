# frozen_string_literal: true

class Participant < ApplicationRecord
  include GreenlightSerializedAttributes

  serialize :history, Serializers::HashSerializer
end
