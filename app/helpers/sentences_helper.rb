module SentencesHelper
  def highlight_text(text, keyword, css_class)
    return text unless keyword.present?
    regex = Regexp.new("(#{Regexp.escape(keyword)})", Regexp::IGNORECASE)
    text.gsub(regex, "<span class='#{css_class}'>\\1</span>").html_safe
  end
end
