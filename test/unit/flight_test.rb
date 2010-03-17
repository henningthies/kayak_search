require 'test_helper'

class FlightTest < ActiveSupport::TestCase
  
  def setup
    stub_get(FakewebUrls::GEOHAM, "fakeweb_geoham.response")
    stub_get(FakewebUrls::GEOLHR, "fakeweb_geolhr.response")
    @flight = Flight.new(:origin => "Hamburg", :destination => "London", :depart_date => "2010-04-02")
    @flight.save   
  end
  subject { @flight }
  should_validate_presence_of :origin
  should_validate_presence_of :destination
  should_validate_presence_of :depart_date
  
  should_belong_to :departure_airport
  should_belong_to :arrival_airport
  should_have_one :kayak_request
  
  
  def test_should_respond_to_departure_airport
    flight = flights(:ham_lhr)
    assert_respond_to flight, :departure_airport
  end

  def test_should_respond_to_arrival_airport
    flight = flights(:ham_lhr)
    assert_respond_to flight, :arrival_airport
  end
  
  def test_should_find_next_departure_airport
    assert_equal "HAM", @flight.departure_airport.iata_code
  end

  def test_should_find_next_arrival_airport
     assert_equal "LCY", @flight.arrival_airport.iata_code
   end
  
end
