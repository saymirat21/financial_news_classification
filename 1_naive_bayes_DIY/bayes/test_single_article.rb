require 'yaml'
require_relative '../../articles/import_articles'

# ---- RETRIEVE KEYWORDS/PROBABILITES ----
keywords_probs = YAML.load_file('../yaml_data/keywords_probs.yaml')
# ---- RETRIEVE KEYWORDS/PROBABILITES ----

# ---- RECOGNIZE AND DISPLAY THE RESULTS ----
article = '
Центральный банк и Министерство финансов разработали новую систему добровольных пенсионных накоплений — гарантированный пенсионный план (ГПП). Законопроект презентовали первый зампред ЦБ Сергей Швецов и замминистра финансов Алексей Моисеев. Об этом сообщает «РИА Новости» 29 октября.

ГПП даст возможность жителям России самостоятельно финансировать свою негосударственную пенсию при стимулирующей поддержке государства. Согласно новой системе, пенсионный взнос, который не превышает 6% от зарплаты, освобождается от налога на доход физлиц.

Гибридный продукт: Минфин и ЦБ согласовали проект «второй пенсии»
Новый пенсионный план будет представлен на обсуждение на следующей неделе
Отмечается, что в систему собраны характеристики нескольких продуктов. Например, депозита, так как он защищен гарантией Агентства по страхованию вкладов, и доверительного управления, «где средствами управляют профессионалы и за счет профессионального подхода к управлению длинными деньгами может быть получена доходность, превышающая доходность простых инструментов, того же самого депозита», рассказал Швецов.

«Мы хотим дать возможность гражданам иметь продукт, который позволит им накопить на пенсию таким образом, чтобы это было, с одной стороны, доходно, с другой стороны — гарантированно, с третьей стороны — чтобы инфраструктура была организована таким образом, чтобы не возникало споров между гражданами и пенсионными фондами, и чтобы всегда был ответ на вопрос, кто в этих спорах прав, кто виноват», — заявил Моисеев.
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

