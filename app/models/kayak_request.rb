require 'net/http'
require 'open-uri'

class TripResult < Struct.new(:name, :price, :departure_airport, :arrival_airport, :count, :url)
end


class KayakRequest < ActiveRecord::Base
  
  belongs_to :flight, :touch => true
  
  CURRENCY_RATE = 0.7372 # USD -> EUR
  
  def parse_xml
    results = Array.new
    xml = Nokogiri::XML(self.xml)
    xml.xpath("/searchresult/trips/trip").each do |trip|
      departure_airport = Airport.find(:first, :conditions => {:iata_code => trip.xpath("legs/leg/orig").first.text })
      departure_airport ||= Airport.new
      arrival_airport = Airport.find(:first, :conditions => {:iata_code => trip.xpath("legs/leg/dest").last.text})
      arrival_ariport ||= Airport.new
      price = trip.xpath("price").text.to_f * CURRENCY_RATE
      name = trip.xpath("legs/leg/airline_display").first.text
      url = "http://api.kayak.com/#{trip.xpath("price").first['url']}"
      results << TripResult.new(name, price.to_i, departure_airport.name, arrival_airport.name, nil, url)
    end
    return shrink_results(results)
  end
  
  def shrink_results(results)
    results_shrinked = Array.new
    results.each do |result|
      results_shrinked.each do |shrinked_result|
        if result.name == shrinked_result.name
          shrinked_result.count ||= 1
          shrinked_result.count += 1
          if result.price < shrinked_result.price 
            shrinked_result.price = result.price
            shrinked_result.url = result.url
            shrinked_result.departure_airport = result.departure_airport
            shrinked_result.arrival_airport = result.arrival_airport
          end
          result = nil
        end unless result.nil?
      end
      unless result.nil?
        result.count = 1
        results_shrinked << result   
      end
    end
    return sort_results(results_shrinked)
  end
  
  def sort_results(results)
    sorted_results = results.sort { |a,b| a.price.to_i <=> b.price.to_i }
    return sorted_results
  end
  
  def cache_key
    "kayak_requests/#{self.id}" 
  end
  
  
end
