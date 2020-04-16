require 'libsvm'
require_relative '../../articles/import_articles'

def svm(article)
  model = Libsvm::Model.load('../../3_SVM/SVM/svm-model.bin')

  matches = []

  KEYWORDS.each do |key|
    matches << article.scan(key).length
  end

  prediction = model.predict( Libsvm::Node.features(matches)).round
end
