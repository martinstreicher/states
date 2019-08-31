class CreateParticipants < ActiveRecord::Migration[5.2]
  def change
    create_table :participants do |t|
      t.boolean :active,  null: false, default: true, index: true
      t.jsonb   :history, null: false, default: {}
      t.string  :name,    null: false
      t.string  :uuid,    null: false, index: true
      t.timestamps
    end
  end
end
