# frozen_string_literal: true

class LinesController < ApplicationController
  def index
    @query_text = params[:q]
    @query_regex = params[:regex]
    scope = params[:scope] || "both"

    @lines = []
    @lines = Line.includes(sentence: :corpus_entry)
                   .search_text(@query_text, scope)
                   .order(:line_number)
                   .page(params[:page])
                   .per(20) if @query_text.present?

    @lines = Line.includes(sentence: :corpus_entry)
                 .search_regex(@query_regex, scope)
                 .order(:line_number)
                 .page(params[:page])
                 .per(20) if @query_regex.present?

  end
end
