require 'nbayes'
require_relative '../../articles/import_articles'

# ---- CREATE A MODEL ----
nbayes = NBayes::Base.new
# ---- CREATE A MODEL ----

# ---- SET THE MODEL ----
ARTICLES_SPLITTED.each do |category, category_articles_splitted|
  category_articles_splitted.each do |article_splitted|
    nbayes.train(article_splitted, "#{category.to_s.upcase}")
  end
end
# ---- SET THE MODEL ----

# ---- SAVE THE MODEL ----
nbayes.dump('../yaml_data/nbayes.yml')
# ---- SAVE THE MODEL ----
