# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_12_28_000000) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "biovision_components", comment: "Biovision CMS components", force: :cascade do |t|
    t.integer "priority", limit: 2, default: 1, null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "slug", null: false
    t.jsonb "settings", default: {}, null: false
    t.jsonb "parameters", default: {}, null: false
    t.index ["slug"], name: "index_biovision_components_on_slug", unique: true
  end

  create_table "languages", comment: "Interface languages", force: :cascade do |t|
    t.integer "priority", limit: 2, default: 1, null: false
    t.boolean "active", default: true, null: false
    t.string "slug", null: false
    t.string "code", null: false
  end

  create_table "metric_values", comment: "Component metric values", force: :cascade do |t|
    t.bigint "metric_id", null: false
    t.datetime "time", null: false
    t.integer "quantity", default: 1, null: false
    t.index "date_trunc('day'::text, \"time\")", name: "metric_values_day_idx"
    t.index ["metric_id"], name: "index_metric_values_on_metric_id"
  end

  create_table "metrics", comment: "Component metrics", force: :cascade do |t|
    t.bigint "biovision_component_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "incremental", default: false, null: false
    t.boolean "start_with_zero", default: true, null: false
    t.boolean "show_on_dashboard", default: true, null: false
    t.integer "default_period", limit: 2, default: 7, null: false
    t.integer "value", default: 0, null: false
    t.integer "previous_value", default: 0, null: false
    t.string "name", null: false
    t.index ["biovision_component_id", "name"], name: "index_metrics_on_biovision_component_id_and_name"
    t.index ["biovision_component_id"], name: "index_metrics_on_biovision_component_id"
  end

  add_foreign_key "metric_values", "metrics", on_update: :cascade, on_delete: :cascade
  add_foreign_key "metrics", "biovision_components", on_update: :cascade, on_delete: :cascade
end
