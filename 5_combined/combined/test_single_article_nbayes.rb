require 'yaml'
require_relative '../../articles/import_articles'

def nbayes(article)
  keywords_probs = YAML.load_file('../../1_naive_bayes_DIY/yaml_data/keywords_probs.yaml')

  amount_of_ham =  ARTICLES[:ham].length.to_f
  amount_of_spam = ARTICLES[:spam].length.to_f

  prob_ham = (amount_of_ham/(amount_of_ham + amount_of_spam)).round(5)
  prob_spam = (amount_of_spam/(amount_of_ham + amount_of_spam)).round(5)

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

  recognized_category = article_ham_prob > article_spam_prob ? 0 : 1
end

