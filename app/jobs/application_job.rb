# frozen_string_literal: true

class ApplicationJob < ActiveJob::Base
  UnimplementedMethodError = Class.new StandardError
end
