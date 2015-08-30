# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150829223626) do

  create_table "books", force: :cascade do |t|
    t.string   "title",      limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "books", ["title"], name: "index_books_on_title", unique: true, using: :btree

  create_table "cases", force: :cascade do |t|
    t.integer  "unit_id",     limit: 4
    t.integer  "sequence_id", limit: 4, null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "cases", ["unit_id"], name: "index_cases_on_unit_id", using: :btree

  create_table "components", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.string   "family",     limit: 255
    t.boolean  "reduciable",             null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "components_exercises", force: :cascade do |t|
    t.integer "exercise_id",  limit: 4
    t.integer "component_id", limit: 4
  end

  add_index "components_exercises", ["component_id"], name: "index_components_exercises_on_component_id", using: :btree
  add_index "components_exercises", ["exercise_id"], name: "index_components_exercises_on_exercise_id", using: :btree

  create_table "components_sentences", force: :cascade do |t|
    t.integer "sentence_id",  limit: 4
    t.integer "component_id", limit: 4
  end

  add_index "components_sentences", ["component_id"], name: "index_components_sentences_on_component_id", using: :btree
  add_index "components_sentences", ["sentence_id"], name: "index_components_sentences_on_sentence_id", using: :btree

  create_table "exercises", force: :cascade do |t|
    t.integer  "case_id",     limit: 4
    t.integer  "sequence_id", limit: 4, null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "exercises", ["case_id"], name: "index_exercises_on_case_id", using: :btree

  create_table "exercises_words", force: :cascade do |t|
    t.integer "exercise_id", limit: 4
    t.integer "word_id",     limit: 4
  end

  add_index "exercises_words", ["exercise_id"], name: "index_exercises_words_on_exercise_id", using: :btree
  add_index "exercises_words", ["word_id"], name: "index_exercises_words_on_word_id", using: :btree

  create_table "sentences", force: :cascade do |t|
    t.text     "chinese",      limit: 65535, null: false
    t.text     "english",      limit: 65535, null: false
    t.text     "distractors",  limit: 65535
    t.text     "equivalents",  limit: 65535
    t.integer  "core_id",      limit: 4,     null: false
    t.string   "structure",    limit: 255,   null: false
    t.string   "source_title", limit: 255,   null: false
    t.integer  "grade",        limit: 4,     null: false
    t.integer  "semester",     limit: 4,     null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "sentences_words", force: :cascade do |t|
    t.integer "sentence_id", limit: 4
    t.integer "word_id",     limit: 4
  end

  add_index "sentences_words", ["sentence_id"], name: "index_sentences_words_on_sentence_id", using: :btree
  add_index "sentences_words", ["word_id"], name: "index_sentences_words_on_word_id", using: :btree

  create_table "student_current_records", force: :cascade do |t|
    t.integer  "student_id",  limit: 4
    t.integer  "book_id",     limit: 4, null: false
    t.integer  "unit_id",     limit: 4, null: false
    t.integer  "case_id",     limit: 4, null: false
    t.integer  "video_id",    limit: 4
    t.integer  "exercise_id", limit: 4
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "student_current_records", ["student_id"], name: "index_student_current_records_on_student_id", using: :btree

  create_table "student_learnt_components", force: :cascade do |t|
    t.integer  "student_id",       limit: 4
    t.float    "current_strength", limit: 24,    null: false
    t.text     "strength_history", limit: 65535, null: false
    t.date     "next_test_date"
    t.integer  "test_interval",    limit: 4,     null: false
    t.text     "test_date_array",  limit: 65535, null: false
    t.integer  "component_id",     limit: 4,     null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "student_learnt_components", ["student_id"], name: "index_student_learnt_components_on_student_id", using: :btree

  create_table "student_learnt_words", force: :cascade do |t|
    t.integer  "student_id",       limit: 4
    t.float    "current_strength", limit: 24,    null: false
    t.text     "strength_history", limit: 65535, null: false
    t.date     "next_test_date"
    t.integer  "test_interval",    limit: 4,     null: false
    t.text     "test_date_array",  limit: 65535, null: false
    t.integer  "word_id",          limit: 4,     null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "student_learnt_words", ["student_id"], name: "index_student_learnt_words_on_student_id", using: :btree

  create_table "student_review_records", force: :cascade do |t|
    t.integer  "student_id",     limit: 4
    t.integer  "streak",         limit: 4,     null: false
    t.date     "next_test_date",               null: false
    t.text     "review_history", limit: 65535, null: false
    t.integer  "coins",          limit: 4,     null: false
    t.time     "review_time",                  null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "student_review_records", ["student_id"], name: "index_student_review_records_on_student_id", using: :btree

  create_table "students", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "name",                   limit: 255, default: "", null: false
    t.integer  "grade",                  limit: 4,                null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "students", ["confirmation_token"], name: "index_students_on_confirmation_token", unique: true, using: :btree
  add_index "students", ["email"], name: "index_students_on_email", unique: true, using: :btree
  add_index "students", ["reset_password_token"], name: "index_students_on_reset_password_token", unique: true, using: :btree

  create_table "units", force: :cascade do |t|
    t.integer  "book_id",     limit: 4
    t.string   "subtitle",    limit: 255, null: false
    t.integer  "sequence_id", limit: 4,   null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "units", ["book_id"], name: "index_units_on_book_id", using: :btree
  add_index "units", ["subtitle"], name: "index_units_on_subtitle", unique: true, using: :btree

  create_table "videos", force: :cascade do |t|
    t.integer  "case_id",     limit: 4
    t.string   "youku_id",    limit: 255, null: false
    t.integer  "sequence_id", limit: 4,   null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "videos", ["case_id"], name: "index_videos_on_case_id", using: :btree
  add_index "videos", ["youku_id"], name: "index_videos_on_youku_id", unique: true, using: :btree

  create_table "words", force: :cascade do |t|
    t.string   "chinese",      limit: 255, null: false
    t.string   "english",      limit: 255, null: false
    t.string   "partofspeech", limit: 255, null: false
    t.string   "family",       limit: 255
    t.string   "disctractors", limit: 255
    t.string   "source_title", limit: 255, null: false
    t.integer  "grade",        limit: 4,   null: false
    t.integer  "semester",     limit: 4,   null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

end
