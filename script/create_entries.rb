require 'json'

def parse_metadata(lines)
  metadata = {}
  lines.each do |line|
    break unless line.start_with?("{")
    key, value = line.gsub(/[{}]/, "").split(" = ", 2)
    metadata[key.strip.downcase.to_sym] = value&.strip
  end
  metadata
end

def parse_lines_with_pages(lines)
  current_page = nil
  content = []

  lines.each do |line|
    if line.strip =~ /\{Page = (\d+)\}/
      current_page = $1
    elsif line =~ /^(\d+)\t(.+)$/
      line_number = $1.to_i
      text = $2.strip
      content << { page: current_page, line_number: line_number, text: text }
    end
  end

  content
end


def build_aligned_json(number, tlingit_lines, english_lines, metadata)
  grouped = []

  tlingit_by_ln = tlingit_lines.index_by { |l| l[:line_number] }
  english_by_ln = english_lines.index_by { |l| l[:line_number] }

  all_lns = tlingit_by_ln.keys & english_by_ln.keys

  lines = all_lns.map do |ln|
    {
      line_number: ln,
      line_tlingit: tlingit_by_ln[ln][:text],
      line_english: english_by_ln[ln][:text],
      page_tlingit: tlingit_by_ln[ln][:page],
      page_english: english_by_ln[ln][:page]
    }
  end

  # Group into sentences — split on lines ending in '.', '!', '?' after lowercase letter or '
  sentence_boundaries = lines.each_index.select do |i|
    lines[i][:line_tlingit] =~ /[a-záéíóúýÿʼ][.?!]$/
  end

  # sentence_boundaries = (0..3647).to_a # for 004

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
    print("in fallback")
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

  metadata.slice(:number, :title, :author, :clan, :source, :transcriber, :orthography, :dialect).merge(sentences: sentences)
end

# === MAIN ===
require 'active_support'
require 'active_support/core_ext'
corpus_dir = "../tlingit-corpus"
output_dir = "./json_entries"
Dir.mkdir(output_dir) unless Dir.exist?(output_dir)

valid_entries = ["001", "002", "003", "006", "008", "011", "012", "013", "014", "015", "016", "017", "018", "019", "020", "021", "025", "026", "027", "028", "029", "030", "032"]
# valid_entries = ["004"]
valid_entries.each do |entry_num|
  text_file = Dir.glob("#{corpus_dir}/#{entry_num}*Text.txt").first
  translation_file = Dir.glob("#{corpus_dir}/#{entry_num}*Translation.txt").first
  next unless text_file && translation_file

  tlingit_lines_raw = File.readlines(text_file, chomp: true)
  english_lines_raw = File.readlines(translation_file, chomp: true)

  metadata = parse_metadata(tlingit_lines_raw)

  tlingit_lines = parse_lines_with_pages(tlingit_lines_raw)
  english_lines = parse_lines_with_pages(english_lines_raw)

  json_data = build_aligned_json(entry_num, tlingit_lines, english_lines, metadata)

  File.write("#{output_dir}/#{entry_num}.json", JSON.pretty_generate(json_data))
  puts "Wrote #{entry_num}.json"
end

# Wrote 001.json
# in fallbackWrote 002.json
# in fallbackWrote 003.json
# in fallbackWrote 006.json
# Wrote 008.json
# Wrote 011.json
# Wrote 012.json
# Wrote 013.json
# Wrote 014.json
# Wrote 015.json
# Wrote 016.json
# in fallbackWrote 017.json
# Wrote 018.json
# Wrote 019.json
# Wrote 020.json
# Wrote 021.json
# Wrote 025.json
# Wrote 026.json
# Wrote 027.json
# Wrote 028.json
# Wrote 029.json
# Wrote 030.json
# in fallbackWrote 032.json
