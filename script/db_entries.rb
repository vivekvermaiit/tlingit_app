entry = CorpusEntry.create!(
  number: '001',
  title: "Ḵákʼw / Basket Bay",
  author: "Shaadaaxʼ / Robert Zuboff",
  clan: "Deisheetaan, Kaḵáakʼw Hít; Daḵlʼaweidí yádi",
  source: "D&D 1987:62–71",
  transcriber: "Ḵeixwnéi / Nora Marks Dauenhauer",
  orthography: "RP",
  dialect: "Northern – Coastal – Angoon"
)

sentence1 = entry.sentences.create!(
  sentence_number: 1,
  sentence_tlingit: "Yú haa aaní áyú yú haa aaní, Ḵákʼw áyú yóo duwasáakw; Dleit Ḵáa x̱ʼéinax̱ ḵu.aa, Basket Bay.",
  sentence_english: "That land of ours, that land of ours is called Ḵakʼw; but in English Basket Bay."
)

tlingit_lines1 = [
  "Yú haa aaní áyú",
  "yú haa aaní,",
  "Ḵákʼw áyú yóo duwasáakw;",
  "Dleit Ḵáa x̱ʼéinax̱ ḵu.aa,",
  "Basket Bay."
]

english_lines1 = [
  "That land of ours,",
  "that land of ours",
  "is called Ḵakʼw;",
  "but in English",
  "Basket Bay."
]

(0...5).each do |i|
  sentence1.lines.create!(
    line_number: i + 1,
    line_tlingit: tlingit_lines1[i],
    line_english: english_lines1[i],
    page_tlingit: "62",
    page_english: "63"
  )
end

### second line and sentences

sentence2 = entry.sentences.create!(
  sentence_number: 2,
  sentence_tlingit: "Á áyú, tsaa áyú áa shadux̱íshdeen, yú tlʼátk.",
  sentence_english: "You know, they used to club seals, at that place."
)

tlingit_lines2 = [
  "Á áyú, tsaa áyú áa shadux̱íshdeen,",
  "yú tlʼátk."
]

english_lines2 = [
  "You know, they used to club seals,",
  "at that place."
]

(0...2).each do |i|
  sentence2.lines.create!(
    line_number: i + 1,
    line_tlingit: tlingit_lines2[i],
    line_english: english_lines2[i],
    page_tlingit: "62",
    page_english: "63"
  )
end


entry=CorpusEntry.includes(sentences: :lines).find(1)
entry.as_json(include: {
  sentences: {
    include: :lines
  }
})

line = Line.includes(sentence: :corpus_entry).find(1)

line.as_json(include: {
  sentence: {
    include: :corpus_entry
  }
})

line.as_json(
  include: {
    sentence: {
      except: [:id, :created_at, :updated_at],
      include: {
        corpus_entry: {
          except: [:id, :created_at, :updated_at]
        }
      }
    }
  },
  except: [:id, :created_at, :updated_at]
)

