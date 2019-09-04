# frozen_string_literal: true

class ApplicationJob < ActiveJob::Base
  include Memery

  UnimplementedMethodError = Class.new StandardError
end
