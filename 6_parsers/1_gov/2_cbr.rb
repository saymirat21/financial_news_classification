require 'nokogiri'
require 'open-uri'
require_relative '../../5_combined/combined/test_single_article_fann'

link = 'http://www.cbr.ru/rss/eventrss'

doc = Nokogiri::XML(open(link))
items = doc.xpath('//channel//item')

items.each do |item|
  title_raw = item.css('title').text
  title = title_raw.split.join(' ')

  link = item.css('link').text

  article = Nokogiri::HTML(open(link), nil, Encoding::UTF_8.to_s)

  article_content_raw = article.css('.landing-text').text
  article_filtered = article_content_raw.strip.downcase
  article = article_filtered.gsub(/[^а-я]/,' ').split.join(' ')

  if fann(article) == 0
    puts "#{article_content_raw}\n\n"
  end
end