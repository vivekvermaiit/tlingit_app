require 'set'

corpus_dir = "../tlingit-corpus"
entries = (1..33).map { |i| format("%03d", i) }

# Collect all files
files = Dir.entries(corpus_dir).select { |f| f.ends_with? ".txt" }

valid_entries = []

# both text and translation exist and have same number of lines.
entries.each do |number|
  text_file = files.select {|x| x.starts_with? number and x.ends_with? "Text.txt"}
  translation_file = files.select {|x| x.starts_with? number and x.ends_with? "Translation.txt"}
  if text_file.size > 0 and translation_file.size > 0
    text_content = File.readlines(corpus_dir+'/'+text_file.first, chomp: true)
    num_lines_text =  text_content.last.split("\t").first
    translation_content = File.readlines(corpus_dir+'/'+translation_file.first, chomp: true)
    num_lines_translation =  translation_content.last.split("\t").first
    valid_entries << number if num_lines_text == num_lines_translation
  end
end

valid_entries = ["001", "002", "003", "004", "006", "008", "011", "012", "013", "014", "015", "016", "017", "018", "019", "020", "021", "025", "026", "027", "028", "029", "030", "032"]


require 'json'

corpus_dir = "../tlingit-corpus"
output_dir = "./output_jsons"
Dir.mkdir(output_dir) unless Dir.exist?(output_dir)

valid_entries = ["001", "002", "003", "004", "006", "008", "011", "012", "013", "014", "015", "016", "017", "018", "019", "020", "021", "025", "026", "027", "028", "029", "030", "032"]

valid_entries.each do |entry_number|
  text_path = Dir.glob("#{corpus_dir}/#{entry_number}*Text.txt").first
  translation_path = Dir.glob("#{corpus_dir}/#{entry_number}*Translation.txt").first

  tlingit_lines = File.readlines(text_path, chomp: true)
  english_lines = File.readlines(translation_path, chomp: true)

  if tlingit_lines.size != english_lines.size
    puts "Skipping #{entry_number}: line count mismatch"
    next
  end

  lines = []
  tlingit_lines.each_with_index do |line, idx|
    line_number, line_tlingit = line.split("\t", 2)
    _, line_english = english_lines[idx].split("\t", 2)

    lines << {
      line_number: line_number.to_i,
      line_tlingit: line_tlingit,
      line_english: line_english,
      page_tlingit: nil,
      page_english: nil
    }
  end

  # Group into sentences — split on lines ending in '.', '!', '?' after lowercase letter
  sentence_boundaries = lines.each_index.select do |i|
    lines[i][:line_tlingit] =~ /[a-záéíóúýÿ]\.$/
  end

  sentences = []
  start_idx = 0
  sentence_number = 1
  sentence_boundaries.each do |end_idx|
    sentence_lines = lines[start_idx..end_idx]
    sentence_tlingit = sentence_lines.map { _1[:line_tlingit] }.join(" ")
    sentence_english = sentence_lines.map { _1[:line_english] }.join(" ")
    sentences << {
      sentence_number: sentence_number,
      sentence_tlingit: sentence_tlingit.strip,
      sentence_english: sentence_english.strip,
      lines: sentence_lines
    }
    sentence_number += 1
    start_idx = end_idx + 1
  end

  # Fallback for dangling lines
  if start_idx < lines.size
    sentence_lines = lines[start_idx..]
    sentence_tlingit = sentence_lines.map { _1[:line_tlingit] }.join(" ")
    sentence_english = sentence_lines.map { _1[:line_english] }.join(" ")
    sentences << {
      sentence_number: sentence_number,
      sentence_tlingit: sentence_tlingit.strip,
      sentence_english: sentence_english.strip,
      lines: sentence_lines
    }
  end

  # Guess metadata from filename
  metadata = File.basename(text_path).gsub(".txt", "").split(" - ")
  title = metadata[1] rescue "Unknown"
  author = metadata[0].gsub(entry_number, "").strip rescue "Unknown"

  output = {
    number: entry_number,
    title: title,
    author: author,
    clan: nil,
    source: nil,
    transcriber: nil,
    orthography: nil,
    dialect: nil,
    sentences: sentences
  }

  File.write("#{output_dir}/#{entry_number}.json", JSON.pretty_generate(output))
  puts "Wrote #{output_dir}/#{entry_number}.json"
end
