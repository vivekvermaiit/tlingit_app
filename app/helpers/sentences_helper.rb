module SentencesHelper
  def highlight_text(text, keyword_text = nil, keyword_regex = nil, css_class = 'keyword-highlight')
    return text unless keyword_text.present? || keyword_regex.present?

    if keyword_regex.present?
      begin
        regex = Regexp.new("(#{keyword_regex})")
      rescue RegexpError
        # fallback to keyword_text if regex is invalid
        regex = keyword_text.present? ? Regexp.new("(#{Regexp.escape(keyword_text)})", Regexp::IGNORECASE) : nil
      end
    elsif keyword_text.present?
      regex = Regexp.new("(#{Regexp.escape(keyword_text)})", Regexp::IGNORECASE)
    end

    return text unless regex

    text.gsub(regex, "<span class='#{css_class}'>\\1</span>").html_safe
  end
end
