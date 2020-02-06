require 'ruby-fann'
require_relative '../../articles/import_articles'

# ---- LOAD THE MODEL AND DATASETS ----
fann = RubyFann::Standard.new(filename: 'fann.trained')
# ---- LOAD THE MODEL AND DATASETS ----

# ---- RECOGNIZE AND DISPLAY THE RESULTS ----
amounts = { spam: ARTICLES[:spam].length.to_f, ham: ARTICLES[:ham].length.to_f }

ARTICLES.each do |category, category_articles|
  counters = { spam: 0, ham: 0 }

  category_articles.each do |article|
    matches = []
    KEYWORDS.each do |key|
      matches << article.scan(key).length
    end
    prediction = fann.run(matches)
    recognized_category = (prediction[0].round == 0 ? :ham : :spam)
    counters[recognized_category] += 1
  end

  puts "Категория #{category.upcase}"
  puts "Всего статей: #{amounts[category].to_i}"
  puts "Количество статей, отнесенных к ham: #{counters[:ham]} (#{((counters[:ham]/amounts[category])*100).round(2)}%)"
  puts "Количество статей, отнесенных к spam: #{counters[:spam]} (#{((counters[:spam]/amounts[category])*100).round(2)}%)"
  print "\n"
end
# ---- RECOGNIZE AND DISPLAY THE RESULTS ----
