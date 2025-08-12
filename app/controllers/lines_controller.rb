# frozen_string_literal: true

class LinesController < ApplicationController
  def index
    @query = params[:q]

    @lines = if @query.present?
               Line.includes(sentence: :corpus_entry).search_text(@query).order(:line_number).limit(50)
    else
               []
    end
  end
end
