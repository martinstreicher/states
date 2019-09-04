# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_09_03_012012) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "participants", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.jsonb "history", default: {}, null: false
    t.string "name", null: false
    t.string "uuid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_participants_on_active"
    t.index ["uuid"], name: "index_participants_on_uuid"
  end

  create_table "schedules", force: :cascade do |t|
    t.datetime "history", default: [], array: true
    t.string "name"
    t.string "scheduleable_type"
    t.bigint "scheduleable_id"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_schedules_on_name"
    t.index ["scheduleable_type", "scheduleable_id"], name: "index_schedules_on_scheduleable_type_and_scheduleable_id"
    t.index ["type"], name: "index_schedules_on_type"
  end

  create_table "scripts", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "participant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["participant_id"], name: "index_scripts_on_participant_id"
  end

  create_table "sidekiq_jobs", force: :cascade do |t|
    t.string "jid"
    t.string "queue"
    t.string "class_name"
    t.text "args"
    t.boolean "retry"
    t.datetime "enqueued_at"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.string "status"
    t.string "name"
    t.text "result"
    t.index ["class_name"], name: "index_sidekiq_jobs_on_class_name"
    t.index ["enqueued_at"], name: "index_sidekiq_jobs_on_enqueued_at"
    t.index ["finished_at"], name: "index_sidekiq_jobs_on_finished_at"
    t.index ["jid"], name: "index_sidekiq_jobs_on_jid"
    t.index ["queue"], name: "index_sidekiq_jobs_on_queue"
    t.index ["retry"], name: "index_sidekiq_jobs_on_retry"
    t.index ["started_at"], name: "index_sidekiq_jobs_on_started_at"
    t.index ["status"], name: "index_sidekiq_jobs_on_status"
  end

  create_table "transitions", force: :cascade do |t|
    t.datetime "expire_at"
    t.json "metadata", default: {}
    t.boolean "minor", default: false, null: false
    t.boolean "most_recent", default: false, null: false
    t.integer "sort_key", null: false
    t.string "to_state", null: false
    t.datetime "transition_at"
    t.string "transitionable_type", null: false
    t.bigint "transitionable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expire_at"], name: "index_transitions_on_expire_at", where: "(expire_at IS NOT NULL)"
    t.index ["transition_at"], name: "index_transitions_on_transition_at", where: "(transition_at IS NOT NULL)"
    t.index ["transitionable_id", "transitionable_type", "minor"], name: "tid_ttype_minor"
    t.index ["transitionable_id", "transitionable_type", "most_recent"], name: "tid_ttype_most_recent", unique: true, where: "(most_recent IS TRUE)"
    t.index ["transitionable_id", "transitionable_type", "sort_key"], name: "tid_ttype_sort_key", unique: true
    t.index ["transitionable_id", "transitionable_type"], name: "index_transitions_on_transitionable_id_and_transitionable_type"
    t.index ["transitionable_type", "transitionable_id"], name: "index_transitions_on_transitionable_type_and_transitionable_id"
  end

end
