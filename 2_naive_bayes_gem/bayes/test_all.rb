require 'nbayes'
require_relative '../../articles/import_articles'

# ---- RETRIEVE SET MODEL ----
nbayes = NBayes::Base.from('../yaml_data/nbayes.yml')
# ---- RETRIEVE SET MODEL ----

# ---- RECOGNIZE AND DISPLAY THE RESULT ----
ARTICLES_SPLITTED.each do |category, category_articles_splitted|
  counters = { spam: 0, ham: 0 }
  amounts = { spam: ARTICLES[:spam].length.to_f, ham: ARTICLES[:ham].length.to_f }

  category_articles_splitted.each do |article_splitted|
    result = nbayes.classify(article_splitted)
    counters[category] += 1
  end

  puts "Категория #{category.upcase}"
  puts "Всего статей: #{amounts[category].to_i}"
  puts "Количество статей отнесенных к ham: #{counters[:ham]} (#{((counters[:ham]/amounts[category])*100).round(2)}%)"
  puts "Количество статей отнесенных к spam: #{counters[:spam]} (#{((counters[:spam]/amounts[category])*100).round(2)}%)"
  print "\n\n" 
end
# ---- RECOGNIZE AND DISPLAY THE RESULT----


