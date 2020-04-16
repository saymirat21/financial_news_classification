require 'nokogiri'
require 'open-uri'

link = 'https://www.nalog.ru/rn02/rss/'

doc = Nokogiri::XML(open(link))
items = doc.xpath('//channel//item')

items.each do |item|
  title_raw = item.css('title').text
  title = title_raw.split.join(' ')
  link = item.css('link').text
  #text.gsub(/[^А-я0-9]/,' ')
end