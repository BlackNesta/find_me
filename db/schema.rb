# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2026_06_03_193704) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "brand_users", force: :cascade do |t|
    t.bigint "brand_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["brand_id", "user_id"], name: "index_brand_users_on_brand_id_and_user_id", unique: true
    t.index ["brand_id"], name: "index_brand_users_on_brand_id"
    t.index ["user_id"], name: "index_brand_users_on_user_id"
  end

  create_table "brands", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "users_count", default: 0, null: false
    t.index "lower((name)::text)", name: "index_brands_on_lower_name", unique: true
  end

  create_table "settings", force: :cascade do |t|
    t.string "settable_type", null: false
    t.bigint "settable_id", null: false
    t.string "key", limit: 255
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["settable_type", "settable_id", "key"], name: "index_settings_on_settable_and_key", unique: true
    t.index ["settable_type", "settable_id"], name: "index_settings_on_settable"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", limit: 255, null: false
    t.string "last_name", limit: 255, null: false
    t.string "email", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "lower((email)::text)", name: "index_users_on_lower_email", unique: true
  end

  add_foreign_key "brand_users", "brands"
  add_foreign_key "brand_users", "users"
end
