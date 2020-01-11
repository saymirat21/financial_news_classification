require 'yaml'
require 'libsvm'
require_relative '../../articles/import_articles'

# ---- RETRIEVE APPROVED ARTICLES ----
approved_articles = YAML.load_file('../yaml_data/approved_articles.yaml')
# ---- RETRIEVE APPROVED ARTICLES ----

# ---- COMPOSE TRAINING DATA SETS ----
input, output = [], []

approved_articles.each do |category, category_articles|
  category_articles.each do |article|
    matches = []
    KEYWORDS.each do |key|
      matches << article.scan(key).length
    end
  input << matches
  output << (category == :ham ? 0 : 1)
  end
end

input_test, input_train, output_test, output_train = [], [], [], []

input.each_with_index do |array, index|
  if index % 10 == 0  
   input_test << array 
   output_test << output[index] 
  else
   input_train << array
   output_train << output[index] 
  end
end
# ---- COMPOSE TRAINING DATA SETS ----

# ---- SET AND TRAIN SVM MODEL ----
parameter = Libsvm::SvmParameter.new
parameter.cache_size = 1 # in megabytes
parameter.eps = 0.001
parameter.c = 1
parameter.gamma = 0.01
parameter.kernel_type = Libsvm::KernelType::RBF

input_train  = input_train.map {|feature_row| Libsvm::Node.features(feature_row) }

problem = Libsvm::Problem.new
problem.set_examples(output_train, input_train)

model = Libsvm::Model.train(problem, parameter)
# ---- SET AND TRAIN SVM MODEL ----

# ---- ESTIMATE ACCURACY ON TESTING DATA SET ----
false_predictions = { 0 => 0, 1 => 0 }

input_test.each_with_index do |input_array, index|
  prediction = model.predict( Libsvm::Node.features(input_array))
  false_predictions[output_test[index]] += 1 if prediction.to_i != output_test[index]
end

puts "Статей в тестовой выборке: #{output_test.length}"
puts "Неверно классифицированных статей: #{false_predictions.values.sum}"
puts "Точность: #{(100 - (false_predictions.values.sum / output_test.length.to_f)*100).round(5)}%"

false_predictions.each do |category, counter|
  print 'Категория ', category == 0 ? "ham. " : "spam. "
  puts "Количество неверно классифицированных статей: #{counter}"
end
# ---- ESTIMATE ACCURACY ON TESTING DATA SET ----

# ---- SAVE THE MODEL ----
model.save('svm-model.bin')
# ---- SAVE THE MODEL----
