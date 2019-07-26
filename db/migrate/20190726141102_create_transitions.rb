class CreateTransitions < ActiveRecord::Migration[5.2]
  def change
    create_table :transitions do |t|
      t.json       :metadata,       default: {}
      t.boolean    :most_recent,    null: false
      t.belongs_to :transitionable, polymorphic: true, null: false
      t.integer    :sort_key,       null: false
      t.string     :to_state,       null: false
      t.timestamps                  null: false
    end

    add_index :transitions, %i[transitionable_id transitionable_type], unique: true
    add_index :transitions, %i[transitionable_id transitionable_type sort_key], unique: true
    add_index :transitions, %i[transitionable_id transitionable_type most_recent], unique: true
  end
end
