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

ActiveRecord::Schema.define(version: 2020_10_24_053822) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "email", null: false
    t.json "tokens"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["confirmation_token"], name: "index_admins_on_confirmation_token", unique: true
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_admins_on_uid_and_provider", unique: true
  end

  create_table "options", force: :cascade do |t|
    t.bigint "quiz_id", null: false
    t.integer "number", null: false
    t.string "text", limit: 128, null: false
    t.boolean "is_correct_answer", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["number", "quiz_id"], name: "index_options_on_number_and_quiz_id", unique: true
    t.index ["number"], name: "index_options_on_number"
    t.index ["quiz_id"], name: "index_options_on_quiz_id"
  end

  create_table "quiz_sets", force: :cascade do |t|
    t.bigint "admin_id", null: false
    t.string "title", limit: 128, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["admin_id"], name: "index_quiz_sets_on_admin_id"
  end

  create_table "quizzes", force: :cascade do |t|
    t.bigint "quiz_set_id", null: false
    t.integer "number", null: false
    t.string "text", limit: 256, null: false
    t.string "question_image"
    t.string "answer_image"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["number", "quiz_set_id"], name: "index_quizzes_on_number_and_quiz_set_id", unique: true
    t.index ["number"], name: "index_quizzes_on_number"
    t.index ["quiz_set_id"], name: "index_quizzes_on_quiz_set_id"
  end

  add_foreign_key "options", "quizzes"
  add_foreign_key "quiz_sets", "admins"
  add_foreign_key "quizzes", "quiz_sets"
end
