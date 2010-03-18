require 'test_helper'

class FlightTest < ActiveSupport::TestCase
  
  def setup
    stub_get(FakewebUrls::GEOHAM, "fakeweb_geoham.response")
    stub_get(FakewebUrls::GEOLHR, "fakeweb_geolhr.response")
    stub_get(FakewebUrls::BUZZ, "fakeweb_buzz.response")
    stub_get(FakewebUrls::SID, "fakeweb_sid.response")
    stub_get(FakewebUrls::SEARCHID, "fakeweb_searchid.response")  
    FakeWeb.register_uri(:get, FakewebUrls::XMLFIRST, [
      {:body => fixture_file("fakeweb_xmlfirst.response"), :status => ["200", "OK"]}, 
      {:body => fixture_file("fakeweb_xmlsecond.response"), :status => ["200", "OK"]}      
      ])
    stub_get(FakewebUrls::XMLALL, "fakeweb_xmlall.response")
    @flight = Flight.new(:origin => "Hamburg", :destination => "London")
    @flight.save   
  end
  subject { @flight }
  should_validate_presence_of :origin
  should_validate_presence_of :destination
  should_validate_presence_of :depart_date
  should_validate_presence_of :return_date
  should_belong_to :departure_airport
  should_belong_to :arrival_airport  
  
  def test_should_respond_to_departure_airport
    flight = flights(:ham_lcy)
    assert_respond_to flight, :departure_airport
  end

  def test_should_respond_to_arrival_airport
    flight = flights(:ham_lcy)
    assert_respond_to flight, :arrival_airport
  end
  
  def test_should_find_next_departure_airport
    assert_equal "HAM", @flight.departure_airport.iata_code
  end

  def test_should_find_next_arrival_airport
    assert_equal "LCY", @flight.arrival_airport.iata_code
  end
  
  def test_should_respond_to_kayak_search_response
    assert_nil @flight.kayak_search_response
    kayak_flight_search = KayakFlightSearch::Client.new
    result = kayak_flight_search.lookup(:depart_airport => "HAM", :arrival_airport => "LCY")
    @flight.update_attributes(:kayak_search_response => result.response)
    assert_equal "true", @flight.kayak_search_response.more_pending
  end
  
end
