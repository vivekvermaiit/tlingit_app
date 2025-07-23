class CorpusEntry < ApplicationRecord
  has_many :sentences, dependent: :destroy
end
