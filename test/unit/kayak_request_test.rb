require 'test_helper'

class KayakRequestTest < ActiveSupport::TestCase
  # Replace this with your real tests.  

  def setup
    @kayak_request = kayak_requests(:ham_lhr)
  end
  subject { @kayak_request }

  should_belong_to :flight
  
  def test_should_parse_xml
    @results = @kayak_request.parse_xml
    assert_instance_of Array, @results
    assert_instance_of TripResult, @results[0]
    assert_equal "Air Berlin", @results[0].name
    xml = Nokogiri::XML(@kayak_request.xml)
    xml.xpath("/searchresult/trips/trip").each do |trip|
      departure_airport = Airport.find_or_create_by_iata_code(trip.xpath("legs/leg/orig").text)
      arrival_airport =  Airport.find_or_create_by_iata_code(trip.xpath("legs/leg/dest").text)
      assert_instance_of Airport, departure_airport
      assert_instance_of Airport, arrival_airport
    end
  end
  
  def test_should_group_results
    @results = @kayak_request.parse_xml
    @results = @kayak_request.shrink_results(@results)
    assert_equal 4, @results.size
    assert_equal 1, @results[0].count
  end
  
  def test_should_sort_results
    @results = @kayak_request.parse_xml
    sorted_results = @kayak_request.sort_results(@results.shuffle)
    assert_equal @results[0].price, sorted_results[0].price
    assert_equal @results[1].price, sorted_results[1].price
  end
  
end
