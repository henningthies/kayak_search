require 'test_helper'

class KayakRequestTest < ActiveSupport::TestCase
  # Replace this with your real tests.  

  def setup
    flight = Flight.first
    f = File.open(RAILS_ROOT+"/tmp/test.xml","r")
    @kayak_request = flight.kayak_request
    @kayak_request.xml = f.read 
    f.close
    @results = flight.kayak_request.parse_xml
  end
  subject { @kayak_request }
  
  
  should_belong_to :flight
  
  def test_should_parse_xml
    assert_instance_of Array, @results
    assert_instance_of TripResult, @results[0]
    assert_equal "Air Berlin", @results[0].name
  end
  
  def test_should_group_results
    @results = @kayak_request.shrink_results(@results)
    assert_equal 4, @results.size
    assert_equal 1, @results[0].count
  end
  
  def test_should_sort_results
    sorted_results = @kayak_request.sort_results(@results.shuffle)
    assert_equal @results[0].price, sorted_results[0].price
    assert_equal @results[1].price, sorted_results[1].price
  end
  
end
