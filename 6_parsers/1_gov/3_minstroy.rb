require 'nokogiri'
require 'open-uri'
require_relative '../../5_combined/combined/test_single_article_fann'

link = 'https://www.minstroyrf.ru/bitrix/rss.php?ID=2&LIMIT=50'

doc = Nokogiri::XML(open(link))
items = doc.xpath('//channel//item')

items.each do |item|
  title_raw = item.css('title').text
  title = title_raw.split.join(' ')

  link = item.css('link').text

  description_raw = item.css('description').text
  description_filtered = description_raw.strip.downcase
  description = description_filtered.gsub(/[^а-я]/,' ').split.join(' ')

  if fann(description) == 0
    puts "#{description}\n\n"
  end
end