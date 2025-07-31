# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


require 'json'

json_dir = Rails.root.join("json_entries")
json_files = Dir.glob("#{json_dir}/*.json").sort

puts "Seeding #{json_files.size} corpus entries from #{json_dir}..."

json_files.each do |file_path|
  begin
    json_data = JSON.parse(File.read(file_path))

    # Convert to nested attributes
    json_data["sentences_attributes"] = json_data.delete("sentences")
    json_data["sentences_attributes"].each do |sentence|
      sentence["lines_attributes"] = sentence.delete("lines")
    end

    CorpusEntry.create!(json_data)
    puts "✅ Seeded: #{File.basename(file_path)}"
  rescue => e
    puts "❌ Failed to seed #{File.basename(file_path)}: #{e.class} - #{e.message}"
  end
end

puts "🌱 Done seeding corpus entries."