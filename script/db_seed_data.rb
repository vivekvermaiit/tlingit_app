
file_path = Rails.root.join("json_entries", "001.json")
json_data = JSON.parse(File.read(file_path))

# Rename keys so Rails accepts them
json_data["sentences_attributes"] = json_data.delete("sentences")
json_data["sentences_attributes"].each do |sentence|
  sentence["lines_attributes"] = sentence.delete("lines")
end

CorpusEntry.create!(json_data)

#rails db:drop db:create db:migrate db:seed