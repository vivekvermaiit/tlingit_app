class Line < ApplicationRecord
  belongs_to :sentence
  has_one :corpus_entry, through: :sentence

  scope :search_text, ->(term) {
    where("line_tlingit LIKE ? OR line_english LIKE ?", "%#{term}%", "%#{term}%")
  }

end
