require 'yaml'
require_relative 'test_single_article_nbayes'
require_relative 'test_single_article_svm'
require_relative 'test_single_article_fann'

# ---- RETRIEVE ARTICLES ----
final_samples = YAML.load_file('../../articles/final_samples.yaml')
# ---- RETRIEVE ARTICLES ----

# ---- RECOGNIZE AND DISPLAY THE RESULTS ----
amounts = { spam: final_samples[:spam].length.to_f, ham: final_samples[:ham].length.to_f }

final_samples.each do |category, units|
  counters = { spam: 0, ham: 0 }

  units.each do |unit_number, unit_content|
    article = unit_content[:content]

    article.downcase!
    article.gsub!(/ё/, 'е')

    predictions = { nbayes:  nbayes(article),
                    svm: svm(article),
                    fann: fann(article)
    }

    prediction = (category == :ham ? predictions[:fann] : predictions[:svm])

    if (predictions[:fann] == predictions[:svm]) && (predictions[:fann] == predictions[:nbayes])
      rate = 1
    elsif predictions[:fann] == predictions[:svm]
      rate = 2
    else
      rate = 3
    end

    recognized_category = (prediction == 0 ? :ham : :spam)
    counters[recognized_category] += 1

    #puts "#{recognized_category} #{predictions[:nbayes]} #{predictions[:svm]} #{predictions[:fann]} = #{rate}"
  end

  puts "Категория #{category.upcase}"
  puts "Всего статей: #{amounts[category].to_i}"
  puts "Количество статей, отнесенных к ham: #{counters[:ham]} (#{((counters[:ham]/amounts[category])*100).round(2)}%)"
  puts "Количество статей, отнесенных к spam: #{counters[:spam]} (#{((counters[:spam]/amounts[category])*100).round(2)}%)"
  print "\n"
end
# ---- RECOGNIZE AND DISPLAY THE RESULTS ----