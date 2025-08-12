class CorpusEntriesController < ApplicationController
  def show
    @corpus_entry = CorpusEntry.find_by(number: params[:id])
  end
end
