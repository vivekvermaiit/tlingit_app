class Sentence < ApplicationRecord
  belongs_to :corpus_entry
  has_many :lines, dependent: :destroy
end
