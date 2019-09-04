# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  include ConcernedWith
  include Memery

  self.abstract_class = true
end
