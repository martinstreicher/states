# module Machineable
#   extend ActiveSupport::Concern
#
#   included do
#     state :pending, initial: true
#     state :expired
#     state :finished
#     state :started
#
#     transition from: :pending, to: :started
#     transition from: :started, to: :expired
#     transition from: :started, to: :finished
#
#     before_transition(to: :finished) do |record, transition|
#       record.finished transition
#     end
#
#     before_transition(from: :pending, to: :started) do |record, transition|
#       record.start transition
#     end
#
#     before_transition(to: :expired) do |record, transition|
#       record.expired transition
#     end
#   end
# end
