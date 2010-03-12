require 'net/http'
require 'open-uri'

desc "Import Airports"
task :import_airports => :environment do
  
  FasterCSV.foreach(RAILS_ROOT+"/airports.dat", :col_sep => ",") do |row|
    
    #puts "airportid:#{row[0]}, Name:#{row[1]}, City:#{row[2]}, Country:#{row[3]}, Iata:#{row[4]}, ICAO:#{row[5]}, lat:#{row[6]}, lng:#{row[7]}"
    
    airport = Airport.new(:airportid => row[0], :name => row[1], :city => row[2], :country => row[3], :iata_code => row[4], :icao_code => row[5], :lat => row[6], :lng => row[7])
    airport.save
    
  end
  
end

desc "Get Routes"
task :get_routes => :environment do
  
  FasterCSV.foreach(RAILS_ROOT+"/routes.dat", :col_sep => ",") do |row|
    depart_airport_id = row[3]
    arrival_airport_id = row[5]

    depart_airport = Airport.find(:first, :conditions => {:airportid => depart_airport_id})
    arrival_airport = Airport.find(:first, :conditions => {:airportid => arrival_airport_id})
    if depart_airport
      depart_airport.outgoings ||= 0
      depart_airport.outgoings += 1
      depart_airport.save
    end
    if arrival_airport
        arrival_airport.incommings ||= 0
        arrival_airport.incommings += 1
        arrival_airport.save
    end

  end
  
end

desc "get missing Coordinates"
task :get_coordinates => :environment do
  airports = Airport.find(:all, :conditions => { :lng => nil})
  airports.each_with_index do |airport, index|
  
  #  xml = Nokogiri::XML(open("http://ws.geonames.org/search?q=#{airport.code}&maxRows=1&featureCode=AIRP&style=short"))
   # airport.lat = xml.xpath("//geoname/lat").text
   # airport.lng = xml.xpath("//geoname/lng").text
   # airport.save
    puts "#{index} missing coordinates: #{airport.code},#{airport.name}, #{airport.location}"
  end
end