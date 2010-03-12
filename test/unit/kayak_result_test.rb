require 'test_helper'

class KayakResultTest < ActiveSupport::TestCase

  def setup
    @kayak_result = KayakResult.new
    flight = Flight.first
    f = File.open(RAILS_ROOT+"/tmp/test.xml","r")
    flight.kayak_request.xml = f.read 
    f.close
    @results = @kayak_result.parse_xml(flight)
  end
  
  def test_should_parse_xml
    assert_instance_of Array, @results
    assert_instance_of TripResult, @results[0]
    assert_equal "Air Berlin", @results[0].name
  end
  
  def test_should_group_results
    @results = @kayak_result.shrink_results(@results)
    assert_equal 4, @results.size
    assert_equal 1, @results[0].count
  end
  
  def test_should_sort_results
    sorted_results = @kayak_result.sort_results(@results.shuffle)
    assert_equal @results[0].price, sorted_results[0].price
    assert_equal @results[1].price, sorted_results[1].price
  end

end
