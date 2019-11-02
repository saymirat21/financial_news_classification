require 'yaml'
require_relative '../../articles/import_articles'

# ---- RETRIEVE KEYWORDS/PROBABILITIES ----
keywords_probs = YAML.load_file('../yaml_data/keywords_probs.yaml')
# ---- RETRIEVE KEYWORDS/PROBABILITIES ----

# ---- RECOGNIZE AND COMPOSE APPROVED ARTICLES ----   
approved_articles = { ham: [], spam: [] }

amounts = { spam: ARTICLES[:ham].length.to_f, ham: ARTICLES[:spam].length.to_f } 
prob_ham = (amounts[:ham]/(amounts[:ham] + amounts[:spam])).round(5)
prob_spam = (amounts[:spam]/(amounts[:ham] + amounts[:spam])).round(5)

ARTICLES.each do |category, category_articles|
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

    recognized_category = article_spam_prob > article_ham_prob ? :spam : :ham 
    approved_articles[category] << article if recognized_category == category
  end
end
# ---- RECOGNIZE AND COMPOSE APPROVED ARTICLES ----

# ---- NORMALIZE APPROVED ARTICLES ----
approved_articles_splitted = { ham: [], spam: [] }

approved_articles.each do |category, category_articles|
  category_articles.each do |category_article|
    category_article.downcase!
    category_article.gsub!(/ё/, 'е')
    category_article_splitted = category_article.split(/[^а-я]/)
    category_article_splitted.delete_if { |word| word.empty? }

    approved_articles_splitted[category] << category_article_splitted
  end
end
# ---- NORMALIZE APPROVED ARTICLES ----

# ---- SAVE APPROVED ARTICLES ----
File.open('../yaml_data/approved_articles_splitted.yaml', 'w') do |file|
  file.truncate(0)
  file.write(approved_articles_splitted.to_yaml)
end
# ---- SAVE APPROVED ARTICLES ----