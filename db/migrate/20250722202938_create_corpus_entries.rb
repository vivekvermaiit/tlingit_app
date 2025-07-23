class CreateCorpusEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :corpus_entries do |t|
      t.string :number, null: false
      t.string :title, null: false
      t.string :author
      t.string :clan
      t.string :source
      t.string :transcriber
      t.string :orthography
      t.string :dialect

      t.timestamps
    end

    create_table :sentences do |t|
      t.integer :sentence_number, null: false
      t.text :sentence_tlingit, null: false, limit: 16.megabytes - 1
      t.text :sentence_english, null: false, limit: 16.megabytes - 1
      t.references :corpus_entry, null: false, foreign_key: true

      t.timestamps
    end

    add_index :sentences, :sentence_tlingit
    add_index :sentences, :sentence_english

    create_table :lines do |t|
      t.integer :line_number, null: false
      t.text :line_tlingit, null: false
      t.text :line_english, null: false
      t.string :page_tlingit, null: false
      t.string :page_english, null: false
      t.references :sentence, null: false, foreign_key: true

      t.timestamps
    end

    add_index :lines, :line_tlingit
    add_index :lines, :line_english

  end
end
