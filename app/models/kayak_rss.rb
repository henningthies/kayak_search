require 'net/http'
require 'open-uri'

class RssResult < Struct.new(:name, :price, :departure_airport, :arrival_airport, :depart_date, :return_date, :url)
end

class KayakRss < ActiveRecord::Base
  
  belongs_to :flight, :touch => true   
  
  def get_results
    doc = Nokogiri::XML(self.get_airport_to_airport)
    @results = Array.new
    
    doc.xpath("/rss/channel/item").each do |item|
      result = RssResult.new(item.xpath("kyk:airline").text, item.xpath("kyk:price").text, item.xpath("kyk:originLocation").text, item.xpath("kyk:destLocation").text, item.xpath("kyk:departDate").text, item.xpath("kyk:returnDate").text, item.xpath("link").text)
      @results << result
    end
    
    if @results.empty?
      doc = Nokogiri::XML(self.get_buzz)
      doc.xpath("/rss/channel/item").each do |item|
        result = RssResult.new(item.xpath("kyk:airline").text, item.xpath("kyk:price").text, item.xpath("kyk:originLocation").text, item.xpath("kyk:destLocation").text, item.xpath("kyk:departDate").text, item.xpath("kyk:returnDate").text, item.xpath("link").text)
        @results << result
      end
    end
    
    return @results      
  end
  
  def get_airport_to_airport
    self.xml = Nokogiri::XML(open("http://api.kayak.com/h/rss/fare?code=#{self.flight.departure_airport.iata_code}&dest=#{self.flight.arrival_airport.iata_code}&mc=EUR"))
    store_data(self.xml, "airport_to_airport.xml")
    return self.xml.to_s
  end
  
  def get_buzz
    self.xml = Nokogiri::XML(open("http://api.kayak.com/h/rss/buzz?code=#{self.flight.departure_airport.iata_code}&mc=EUR"))
    store_data(self.xml, "buzz.xml")
    return self.xml.to_s
  end
  
  
  private
  
  def store_data(xml, file_name)
    File.open("#{RAILS_ROOT}/tmp/kayak_search/#{file_name}","w") do |f|
      f.puts(xml)
    end
  end
  
end