require 'libsvm'
require_relative '../../articles/import_articles'

# ---- PREPARE DATA SETS ----
input, output = [], []

ARTICLES_SPLITTED.each do |category, category_articles|
  category_articles.each do |article|
  matches = []
   KEYWORDS.each do |key|
     counter = 0
     article.each do |word|
        counter += 1 if word.match?(key)
      end
     matches << counter
    end
  input << matches
  output << (category == :ham ? 0 : 1)
  end
end
# ---- PREPARE DATA SETS ----

# ---- RETRIEVE THE MODEL ----
model = Libsvm::Model.load('svm-model.bin')
# ---- RETRIEVE THE MODEL ----

# ---- PERFORM TESTING ----
false_predictions = { 0 => 0, 1 => 0 }

output.each_with_index do |value, index|
  prediction = model.predict( Libsvm::Node.features(input[index]))
  false_predictions[value] += 1 unless prediction.to_i == value
end

[:ham, :spam].each_with_index do |category, index|
  puts "Категория #{category.upcase}"
  puts "Количество статей в категории: #{ARTICLES[category].count}"
  print "Количество неверно классифицированных статей: #{false_predictions[index]}" 
  print "(#{(false_predictions[index]/ARTICLES[category].count.to_f).round(2)*100}%)\n\n"
end
# ---- PERFORM TESTING ----
