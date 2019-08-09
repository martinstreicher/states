class CreateTransitions < ActiveRecord::Migration[5.2]
  def change
    create_table :transitions do |t|
      t.json       :metadata,       default: {}
      t.boolean    :minor,          null: false, default: false
      t.boolean    :most_recent,    null: false
      t.belongs_to :transitionable, polymorphic: true, null: false
      t.integer    :sort_key,       null: false
      t.string     :to_state,       null: false
      t.timestamps                  null: false
    end

    add_index :transitions, %i[transitionable_id transitionable_type]

    add_index :transitions, %i[transitionable_id transitionable_type minor],
      name: :tid_ttype_minor

    add_index :transitions, %i[transitionable_id transitionable_type most_recent],
      name: :tid_ttype_most_recent, unique: true

    add_index :transitions, %i[transitionable_id transitionable_type sort_key],
      name: :tid_ttype_sort_key, unique: true
  end
end
