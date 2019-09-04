class CreateSchedules < ActiveRecord::Migration[5.2]
  def change
    create_table :schedules do |t|
      t.datetime   :history, array: true, default: []
      t.string     :name,   required: false, index: true
      t.belongs_to :scheduleable, polymorphic: true
      t.string     :type,   required: true,  index: true
      t.timestamps
    end
  end
end
