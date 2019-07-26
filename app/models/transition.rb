class Transition < ApplicationRecord
  belongs_to :transitionable, polymorphic: true

  after_destroy :update_most_recent, if: :most_recent?

  private

  def update_most_recent
    last_transition = order.order_transitions.order(:sort_key).last
    return unless last_transition.present?

    last_transition.update_column(:most_recent, true)
  end
end
