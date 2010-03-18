require 'net/http'
require 'date'
require 'nokogiri'

class KayakFlightSearch

  def self.format_date(date)
    if Date===date
      date.strftime("%m-%d-%Y")
    else
      Date.parse(date).strftime("%m-%d-%Y")
    end
  end
  
end

require 'kayak_flight_search/client.rb'
require 'kayak_flight_search/result.rb'
require 'kayak_flight_search/response.rb'
require 'kayak_flight_search/trip.rb'
require 'kayak_flight_search/leg.rb'
require 'kayak_flight_search/segment.rb'