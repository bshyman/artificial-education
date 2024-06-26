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

ActiveRecord::Schema.define(version: 2024_05_25_015000) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "pokemons", force: :cascade do |t|
    t.string "name"
    t.string "pokedex_id"
    t.integer "base_experience"
    t.string "image"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "prizes", force: :cascade do |t|
    t.string "name"
    t.integer "cost"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "questions", force: :cascade do |t|
    t.string "content"
    t.bigint "game_id"
    t.bigint "user_id"
    t.integer "value"
    t.string "submitted_answer"
    t.text "incorrect_answers", default: [], array: true
    t.string "correct_answer"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "difficulty"
    t.string "question_type"
    t.index ["game_id"], name: "index_questions_on_game_id"
    t.index ["user_id"], name: "index_questions_on_user_id"
  end

  create_table "rounds", force: :cascade do |t|
    t.bigint "game_id"
    t.bigint "user_id"
    t.integer "potential_value"
    t.integer "earned_value"
    t.integer "current_question_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["game_id"], name: "index_rounds_on_game_id"
    t.index ["user_id"], name: "index_rounds_on_user_id"
  end

  create_table "user_prizes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "prize_id", null: false
    t.datetime "purchased_at"
    t.datetime "redeemed_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["prize_id"], name: "index_user_prizes_on_prize_id"
    t.index ["user_id"], name: "index_user_prizes_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name"
    t.date "birthday"
    t.integer "xp", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "role"
    t.integer "group_id"
    t.integer "bank", default: 0
    t.string "password_digest"
    t.string "email"
  end

  add_foreign_key "user_prizes", "prizes"
  add_foreign_key "user_prizes", "users"
end
