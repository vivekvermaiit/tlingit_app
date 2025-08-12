class SentencesController < ApplicationController
  def show
    @sentence = Sentence.includes(:corpus_entry).find(params[:id])
    @corpus_entry = @sentence.corpus_entry
    @keyword = params[:keyword].presence
    @show_context = params[:show_context].present?
    @page_tlingit = params[:page_tlingit].presence
    @page_english = params[:page_english].presence

    if @show_context
      @prev_sentence = Sentence.where(corpus_entry_id: @corpus_entry.id)
                               .where("sentence_number < ?", @sentence.sentence_number)
                               .order(sentence_number: :desc)
                               .first
      @next_sentence = Sentence.where(corpus_entry_id: @corpus_entry.id)
                               .where("sentence_number > ?", @sentence.sentence_number)
                               .order(:sentence_number)
                               .first
    end
  end
end
