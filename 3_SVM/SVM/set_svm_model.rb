require 'yaml'
require 'libsvm'
require_relative '../../articles/import_articles'

# ---- RETRIEVE APPROVED ARTICLES ----
approved_articles_splitted = YAML.load_file('../yaml_data/approved_articles_splitted.yaml')
# ---- RETRIEVE APPROVED ARTICLES ----

# ---- PROCESS TRAINING DATA SETS ----
input, output = [], []

approved_articles_splitted.each do |category, category_articles|
  category_articles.each do |article|
  matches = []
  KEYWORDS.each do |key|
    counter = 0
    article.each do |word|
      counter += 1 if word.match?(key)
    end
    matches << counter
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
# ---- PROCESS TRAINING DATA SETS ----

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

# ---- SAVE THE MODEL ----
model.save('svm-model.bin')
# ---- SAVE THE MODEL ----
