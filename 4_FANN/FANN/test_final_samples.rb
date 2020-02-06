require 'yaml'
require 'ruby-fann'
require_relative '../../articles/import_articles'

# ---- RETRIEVE ARTICLES AND THE MODEL ----
final_samples = YAML.load_file('../../articles/final_samples.yaml')
fann = RubyFann::Standard.new(filename: 'fann.trained')
# ---- RETRIEVE ARTICLES AND THE MODEL ----

# ---- RECOGNIZE AND DISPLAY THE RESULTS ----
amounts = { spam: final_samples[:spam].length.to_f, ham: final_samples[:ham].length.to_f }

final_samples.each do |category, units|
  counters = { spam: 0, ham: 0 }

  units.each do |unit_number, unit_content|
    article = unit_content[:content]

    article.downcase!
    article.gsub!(/ё/, 'е')

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