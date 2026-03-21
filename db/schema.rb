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

ActiveRecord::Schema[7.2].define(version: 2026_03_21_175047) do
  create_table "bets", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "market_id", null: false
    t.integer "market_option_id", null: false
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.boolean "anonymous", default: false, null: false
    t.decimal "payout_amount", precision: 10, scale: 2
    t.boolean "settled", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "market_id"], name: "index_bets_on_user_id_and_market_id"
  end

  create_table "market_options", force: :cascade do |t|
    t.integer "market_id", null: false
    t.string "label", null: false
    t.decimal "total_amount", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["market_id"], name: "index_market_options_on_market_id"
  end

  create_table "markets", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.string "market_type", default: "binary", null: false
    t.string "status", default: "open", null: false
    t.decimal "house_cut_pct", precision: 5, scale: 2, default: "5.0", null: false
    t.integer "creator_id", null: false
    t.integer "pool_id"
    t.datetime "end_time", null: false
    t.integer "resolved_option_id"
    t.string "subject_name"
    t.decimal "total_pool", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_markets_on_creator_id"
    t.index ["status"], name: "index_markets_on_status"
  end

  create_table "pool_memberships", force: :cascade do |t|
    t.integer "user_id"
    t.integer "pool_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pools", force: :cascade do |t|
    t.string "name", null: false
    t.string "pool_type", default: "public", null: false
    t.integer "creator_id", null: false
    t.string "invite_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reports", force: :cascade do |t|
    t.integer "market_id", null: false
    t.integer "reporter_id", null: false
    t.text "reason", null: false
    t.string "status", default: "pending", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.boolean "blacklisted", default: false, null: false
    t.boolean "anonymous_default", default: false, null: false
    t.decimal "balance", precision: 10, scale: 2, default: "100.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end
end
