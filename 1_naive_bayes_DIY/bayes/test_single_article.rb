require 'yaml'
require_relative '../../articles/import_articles'

# ---- RETRIEVE KEYWORDS/PROBABILITES ----
keywords_probs = YAML.load_file('../yaml_data/keywords_probs.yaml')
# ---- RETRIEVE KEYWORDS/PROBABILITES ----

# ---- RECOGNIZE AND DISPLAY THE RESULTS ----
article = '
Объем вложений в недвижимость на 30% превысит уровень 2018 года Инвесторы предпочитают покупать землю под строительство, а не готовые объекты

По итогам 2019 года инвесторы могут потратить на покупку коммерческой недвижимости и земли в России до $3,8 млрд — в 1,3 раза больше, чем в прошлом году. Рост обеспечен не покупками готовых торговых центров и гостиниц, а вложениями в землю

Консалтинговые компании подвели предварительные итоги 2019 года в сфере инвестиций в недвижимость. Аналитики ожидают, что более трети вложений в этом году придутся на декабрь.

По оценке партнера Colliers International Станислава Бибика, за 11 месяцев 2019 года инвесторы вложили в коммерческую недвижимость в России $1,3 млрд, а по итогам года этот показатель достигнет $2,32 млрд, что на $77 млн меньше, чем годом ранее. Партнер Cushman & Wakefield Денис Соколов прогнозирует общий объем инвестиций более оптимистично — $2,8 млрд. «Это на $500 тыс. больше, чем в прошлом году, однако недостаточно для того, чтобы наполнить ликвидностью сектор коммерческой недвижимости», — уверен Соколов, добавляя, что ожидает роста инвестиций в 2020 году до $3,3–3,9 млрд.

Если добавить к этим цифрам данные о сделках с еще не построенными проектами, фактически — с землей, то получится другая картина. По оценке CBRE, в недвижимость, землю и строящиеся объекты в России в этом году уже инвестировано $2,6 млрд, а к концу года объем сделок составит $3,8 млрд, что в 1,3 раза больше, чем в прошлом году, говорит руководитель отдела рынков, капитала и инвестиций CBRE Ирина Ушакова.






'

article.downcase!
article.gsub!(/ё/, 'е')
# ---- SENTENCE ----



# ---- COMPUTING ----   
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

recognized_category = article_spam_prob > article_ham_prob ? 'SPAM': 'HAM'

puts "Статья классифицирована как: #{recognized_category}"
puts "Вероятность отнесения к категории SPAM: #{article_spam_prob}"
puts "Вероятность отнесения к категории HAM: #{article_ham_prob}"       
# ---- RECOGNIZE AND DISPLAY THE RESULTS ----

