require 'yaml'
require_relative '../../articles/import_articles'

# ---- RETRIEVE PROBABILITIES ----
keywords_probs = YAML.load_file('../yaml_data/keywords_probs.yaml')
# ---- RETRIEVE PROBABILITIES ----

# ---- RECOGNIZE AND DISPLAY THE RESULTS ----   
amounts = { spam: ARTICLES[:spam].length.to_f, ham: ARTICLES[:ham].length.to_f } 

prob_ham = (amounts[:ham]/(amounts[:ham] + amounts[:spam])).round(5)
prob_spam = (amounts[:spam]/(amounts[:ham] + amounts[:spam])).round(5)

ARTICLES.each do |category, category_articles|
  counters = { spam: 0, ham: 0 }
  
  category_articles.each do |article|
    article_occurrences = Hash.new

    keywords_probs.keys.each do |keyword|
      if article.match?(keyword)
        article_occurrences[keyword] = 1
      else
        article_occurrences[keyword] = 0
      end
    end
    
    article_probs = { ham: [],  spam: [] }
	    
    article_occurrences.each do |word, occurrence|
      if occurrence == 1
	article_probs[:ham] << keywords_probs[word][0].join.to_f
	article_probs[:spam] << keywords_probs[word][1].join.to_f
      elsif occurrence == 0
        article_probs[:ham] << 1 - keywords_probs[word][0].join.to_f
	article_probs[:spam] << 1 - keywords_probs[word][1].join.to_f
      end 
    end

    article_probs[:ham] = article_probs[:ham].reduce(:*)
    article_probs[:spam] = article_probs[:spam].reduce(:*)

    article_spam_prob = (article_probs[:spam]*prob_spam)/((article_probs[:ham]*prob_ham) + (article_probs[:spam]*prob_spam))
    article_ham_prob = (article_probs[:ham]*prob_ham)/((article_probs[:ham]*prob_ham) + (article_probs[:spam]*prob_spam))  

    if article_ham_prob > article_spam_prob
      counters[:ham] += 1 
    else
      counters[:spam] += 1 
    end
  end 
  puts "Категория #{category.upcase}"
  puts "Всего статей: #{amounts[category].to_i}"
  puts "Количество статей, отнесенных к ham: #{counters[:ham]} (#{((counters[:ham]/amounts[category])*100).round(2)}%)"
  puts "Количество статей, отнесенных к spam: #{counters[:spam]} (#{((counters[:spam]/amounts[category])*100).round(2)}%)"
  print "\n" 
end
 
# ---- RECOGNIZE AND DISPLAY THE RESULTS ----
