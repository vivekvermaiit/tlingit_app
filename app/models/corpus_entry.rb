class CorpusEntry < ApplicationRecord
  has_many :sentences, dependent: :destroy
  accepts_nested_attributes_for :sentences

end
