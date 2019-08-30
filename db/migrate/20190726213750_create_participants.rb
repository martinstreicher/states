class CreateParticipants < ActiveRecord::Migration[5.2]
  def change
    create_table :participants do |t|
      t.boolean :active, null: false, default: true, index: true
      t.string  :name,   null: false
      t.timestamps
    end
  end
end
