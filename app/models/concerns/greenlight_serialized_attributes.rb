# frozen_string_literal: true

module GreenlightSerializedAttributes
  extend ActiveSupport::Concern

  included do
    store_accessor :history, :welcomed, :enrolled_at
  end
end
