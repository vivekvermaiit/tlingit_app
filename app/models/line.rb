class Line < ApplicationRecord
  belongs_to :sentence
  has_one :corpus_entry, through: :sentence

  scope :search_text, ->(term, scope) {
    case scope
    when "english"
      where("line_english LIKE ?", "%#{term}%")
    when "tlingit"
      where("line_tlingit LIKE ?", "%#{term}%")
    else # both
      where("line_tlingit LIKE ? OR line_english LIKE ?", "%#{term}%", "%#{term}%")
    end
  }

  scope :search_regex, ->(term, scope) {
    case scope
    when "english"
      where("line_english REGEXP ?", term)
    when "tlingit"
      where("line_tlingit REGEXP ?", term)
    else # both
      where("line_tlingit REGEXP ? OR line_english REGEXP ?", term, term)
    end
  }
end
