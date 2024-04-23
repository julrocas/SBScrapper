require 'date'
require 'httparty'
require 'nokogiri'
require 'json'

today = Date.today.strftime("%d/%m/%Y")
one_month_ago = Date.today.prev_month.strftime("%d/%m/%Y")

url = "https://www.sbs.gob.pe/app/stats/seriesH-tipo_cambio_moneda_excel.asp?fecha1=#{one_month_ago}&fecha2=#{today}&moneda=02&cierre="
response = HTTParty.get(url)

doc = Nokogiri::HTML(response)
parsed_data = []

doc.xpath('//table/tr[position() > 1]').each do |row|
  date = row.xpath('td[1]').text.strip
  buy = row.xpath('td[3]').text.strip.to_f
  sell = row.xpath('td[4]').text.strip.to_f

  parsed_data << { date: date, buy: buy, sell: sell }
end

json_data = parsed_data.to_json

File.open('sbs_data.json', 'w') { |file| file.write(json_data) }
