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

ActiveRecord::Schema.define(version: 2019_07_26_213750) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "participants", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "scripts", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transitions", force: :cascade do |t|
    t.json "metadata", default: {}
    t.boolean "minor", default: false, null: false
    t.boolean "most_recent", null: false
    t.string "transitionable_type", null: false
    t.bigint "transitionable_id", null: false
    t.integer "sort_key", null: false
    t.string "to_state", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["transitionable_id", "transitionable_type", "minor"], name: "tid_ttype_minor"
    t.index ["transitionable_id", "transitionable_type", "most_recent"], name: "tid_ttype_most_recent", unique: true, where: "(most_recent IS TRUE)"
    t.index ["transitionable_id", "transitionable_type", "sort_key"], name: "tid_ttype_sort_key", unique: true
    t.index ["transitionable_id", "transitionable_type"], name: "index_transitions_on_transitionable_id_and_transitionable_type"
    t.index ["transitionable_type", "transitionable_id"], name: "index_transitions_on_transitionable_type_and_transitionable_id"
  end

end
