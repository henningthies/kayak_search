require 'net/http'
require 'open-uri'
 
class KayakSearch
    
  API_SERVER = 'http://api.kayak.com'
  
  attr :sid, true
  attr :search_id, true

  def initialize(flight)
    @sid = get_session
    @search_id = get_search_id(:sid => @sid, :depart_date => flight.depart_date, :return_date => flight.return_date, :depart_airport_code => Airport.find(flight.departure_airport_id).iata_code, :arrival_airport_code => Airport.find(flight.arrival_airport_id).iata_code)
  end
  
  
  def get_xml

    if ENV['KAYAK_TEST'] == 'true'
      f = File.open(RAILS_ROOT+"/tmp/test.xml","r")
      xml = Nokogiri::XML(f)
      more_pending = xml.xpath("/searchresult/morepending").text
      count = xml.xpath("/searchresult/count").text.to_i
      f.close
      return count, more_pending, xml.to_s
    end
    
    url = API_SERVER+"/s/apibasic/flight?searchid=#{@search_id}&s=price&c=10&apimode=1&_sid_=#{@sid}"
    xml = Nokogiri::XML(open(url))
    more_pending = xml.xpath("/searchresult/morepending").text
    count = xml.xpath("/searchresult/count").text.to_i
 
    if more_pending.nil? || more_pending != "true" 
      more_pending = "false"
      url = API_SERVER+"/s/apibasic/flight?searchid=#{@search_id}&s=price&c=10&apimode=1&_sid_=#{@sid}"
      xml = Nokogiri::XML(open(url))
    end
    
    store_data(xml,"querydata.xml") if ENV['RAILS_ENV'] == 'development'
    
    return count, more_pending, xml.to_s
  end
  
  private 

  def get_session
    if ENV['KAYAK_TEST'] == 'true'
      return 'DUMMY_KAYAK_SID'
    end
    xml = Nokogiri::XML(open(API_SERVER+"/k/ident/apisession?token=#{ENV['KAYAK_API_KEY']}"))
    @sid = xml.xpath('//sid').text  
    
    store_data(xml,"sid.xml") if ENV['RAILS_ENV'] == 'development'
    return @sid
  end

  def get_search_id(options = {})
    options.assert_valid_keys :sid, :depart_date, :return_date, :travelers, :depart_airport_code, :arrival_airport_code
    
    options[:travelers] ||= 2
    
    if ENV['KAYAK_TEST'] == 'true'
      return 'DUMMY_KAYAK_SEARCHID'
    end
    
    url = API_SERVER+"/s/apisearch?basicmode=true&oneway=n&origin=#{options[:depart_airport_code]}&destination=#{options[:arrival_airport_code]}&destcode=&depart_date=#{format_date(options[:depart_date])}&depart_time=a&&return_date=#{format_date(options[:return_date])}&return_time=a&travelers=#{options[:travelers]}&cabin=e&action=doflights&apimode=1&_sid_=#{options[:sid]}&nearbyO=1&nearbyD=1"
    
    searchid = nil
    xml = Nokogiri::XML(open(url))
    
    store_data(xml,"search_id.xml") if ENV['RAILS_ENV'] == 'development'
    
    searchid = xml.xpath("//searchid")
    
    if searchid
      searchid = searchid.text
    else
      return nil
    end 
    return searchid  
  end
  
  
  def format_date(date)
    if Date===date
      date.strftime("%m-%d-%Y")
    else
      Date.parse(date).strftime("%m-%d-%Y")
    end
  end
  
  def store_data(xml, file_name)
    File.open("#{RAILS_ROOT}/tmp/kayak_search/#{file_name}","w") do |f|
      f.puts(xml)
    end
  end
  
end