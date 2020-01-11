require 'nbayes'
require 'yaml'

# ---- RETRIEVE ARTICLES AND THE MODEL ----
final_samples = YAML.load_file('../../articles/final_samples.yaml')
nbayes = NBayes::Base.from('../yaml_data/nbayes.yml')
# ---- RETRIEVE ARTICLES AND THE MODEL ----

# ---- RECOGNIZE AND DISPLAY THE RESULTS ----

final_samples.each do |category, units|
  print "\nСтатья".ljust(30), 'Категория'.ljust(30), "Присвоенная категория\n"
  puts '-'*85 

  units.each do |unit_number, unit_content|
    article = unit_content[:content]

    article.downcase!
    article.gsub!(/ё/, 'е')
    article_splitted = article.split(/[^а-я]/)
    article_splitted.delete_if { |word| word.empty? }
    
    result = nbayes.classify(article_splitted)
    
    recognized_category = (result.max_class == 'HAM' ? :ham : :spam)
    
    print "#{article[0..20]}...".gsub(/\s/,' ').ljust(30),"#{category}".ljust(30),"#{recognized_category}\n"
  end
end
# ---- RECOGNIZE AND DISPLAY THE RESULTS ----
