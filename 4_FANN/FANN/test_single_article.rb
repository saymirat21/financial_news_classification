require 'ruby-fann'
require_relative '../../articles/import_articles'

# ---- RETRIEVE THE MODEL ----
fann = RubyFann::Standard.new(filename: 'fann.trained')
# ---- RETRIEVE THE MODEL ----

# ---- PROCESS THE ARTICLE ----
article = ' Минфин опубликовал инструкцию по 115‑ФЗ для бухгалтерских фирм
Федеральный закон от 07.08.2001 № 115-ФЗ распространяется на обслуживающие бухгалтерии. Но и сам закон, и другие нормативные документы ориентированы скорее на банки и не учитывают специфику бухгалтерских фирм. Отсюда много вопросов.

Минфин рассмотрел обязанности обслуживающих бухгалтерий в антиотмывочной системе и подробно описал процедуры идентификации клиента, блокировки расчётного счета и другого имущества. Также в документе собраны требования к внутреннему контролю и рекомендации, как фиксировать и хранить информацию о клиентах, информировать Росфинмониторинг о подозрительных операциях.

Лица, оказывающие бухгалтерские услуги, должны контролировать:

привлечение денег для создания компаний;
сделки на рынке недвижимости;
учреждение юридических лиц;
управление денежными средствами, ценными бумагами и другим имуществом.
Если клиент уклоняется от налогов или заключает сделку, в которой нет экономического смысла, бухгалтеру стоит насторожиться. Обслуживающая бухгалтерия должна приостановить сомнительную операцию, запросить подтверждающие документы, присвоить клиенту рисковый статус и уведомить об этом Росфинмониторинг.

Посмотреть и скачать презентацию «Обязанности лиц, оказывающих бухгалтерские услуги, в антиотмывочной системе» можно на официальном сайте Минфина.
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