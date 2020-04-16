require 'ruby-fann'
require_relative '../../articles/import_articles'

# ---- RETRIEVE THE MODEL ----
fann = RubyFann::Standard.new(filename: 'fann.trained')
# ---- RETRIEVE THE MODEL ----

# ---- PROCESS THE ARTICLE ----
article = '
Согласно новой редакции ст   КоАП РФ непредставление отчета СЗВТД всрок илипредставление неполных иили недостоверных сведений влечет засобой предупреждение илиадминистративный штраф длядолжностных лиц вразмере от дорублей Добавим чтоответственность применяется только вотношении должностных лиц заисключением индивидуальных предпринимателей безобразования юридического лица

'

article.downcase!
article.gsub!(/ё/, 'е')

matches = []

KEYWORDS.each do |key|
  matches << article.scan(key).length
end
# ---- PROCESS THE ARTICLE ----

# ---- RECOGNIZE ----
prediction = fann.run(matches)
recognized_category = (prediction[0].round == 0 ? 'HAM' : 'SPAM')
p prediction
# ---- RECOGNIZE ----

# ---- DISPLAY THE RESULT ----
puts "Статья классифицирована как: #{recognized_category}"
# ---- DISPLAY THE RESULT ----