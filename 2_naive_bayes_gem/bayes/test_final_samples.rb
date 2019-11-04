require 'nbayes'
require 'yaml'

# ---- RETRIEVE ARTICLES AND THE MODEL ----
final_samples = YAML.load_file('../../articles/final_samples.yaml')
nbayes = NBayes::Base.from('../yaml_data/nbayes.yml')
# ---- RETRIEVE ARTICLES AND THE MODEL ----

# ---- RECOGNIZE AND DISPLAY THE RESULTS ----
amounts = { spam: final_samples[:spam].length.to_f, ham: final_samples[:ham].length.to_f }

final_samples.each do |category, units|
  counters = { spam: 0, ham: 0 }

  units.each do |unit_number, unit_content|
    article = unit_content[:content]

    article.downcase!
    article.gsub!(/ё/, 'е')
    article_splitted = article.split(/[^а-я]/)
    article_splitted.delete_if { |word| word.empty? }
    
    result = nbayes.classify(article_splitted)
    
    recognized_category = (result.max_class == 'HAM' ? :ham : :spam)
    counters[recognized_category] += 1
  end
 
  puts "Категория #{category.upcase}"
  puts "Всего статей: #{amounts[category].to_i}"
  puts "Количество статей отнесенных к ham: #{counters[:ham]} (#{((counters[:ham]/amounts[category])*100).round(2)}%)"
  puts "Количество статей отнесенных к spam: #{counters[:spam]} (#{((counters[:spam]/amounts[category])*100).round(2)}%)"
  print "\n" 
end
# ---- RECOGNIZE AND DISPLAY THE RESULTS ----

