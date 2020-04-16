require 'ruby-fann'
require_relative '../../articles/import_articles'

def fann(article)
  fann = RubyFann::Standard.new(filename: '../../4_FANN/FANN/fann.trained')

  matches = []

  KEYWORDS.each do |key|
    matches << article.scan(key).length
  end

  prediction = fann.run(matches)
  recognized_category = prediction[0].round
end