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

ActiveRecord::Schema[8.0].define(version: 2025_07_22_202938) do
  create_table "corpus_entries", force: :cascade do |t|
    t.string "number", null: false
    t.string "title", null: false
    t.string "author"
    t.string "clan"
    t.string "source"
    t.string "transcriber"
    t.string "orthography"
    t.string "dialect"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lines", force: :cascade do |t|
    t.integer "line_number", null: false
    t.text "line_tlingit", null: false
    t.text "line_english", null: false
    t.string "page_tlingit", null: false
    t.string "page_english", null: false
    t.integer "sentence_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["line_english"], name: "index_lines_on_line_english"
    t.index ["line_tlingit"], name: "index_lines_on_line_tlingit"
    t.index ["sentence_id"], name: "index_lines_on_sentence_id"
  end

  create_table "sentences", force: :cascade do |t|
    t.integer "sentence_number", null: false
    t.text "sentence_tlingit", limit: 16777215, null: false
    t.text "sentence_english", limit: 16777215, null: false
    t.integer "corpus_entry_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["corpus_entry_id"], name: "index_sentences_on_corpus_entry_id"
    t.index ["sentence_english"], name: "index_sentences_on_sentence_english"
    t.index ["sentence_tlingit"], name: "index_sentences_on_sentence_tlingit"
  end

  add_foreign_key "lines", "sentences"
  add_foreign_key "sentences", "corpus_entries"
end
