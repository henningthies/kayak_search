require 'test_helper'

class KayakRssTest < ActiveSupport::TestCase

  def setup
    stub_get(FakewebUrls::BUZZ, "fakeweb_buzz.response")
    stub_get(FakewebUrls::FARE, "fakeweb_fare.response")
    @flight = flights(:ham_lcy)
    @kayak_rss = KayakRss.new(:flight => @flight)
  end
  subject { @kayak_rss }

  should_belong_to :flight
  
  def test_should_get_airport_to_airport
    assert_instance_of String, @kayak_rss.get_airport_to_airport
  end
  
  def test_should_get_buzz
    assert_instance_of String, @kayak_rss.get_buzz
  end
  
  def test_should_return_array_of_results
    @results = @kayak_rss.get_results
    assert_instance_of Array, @results
    assert_equal 1, @results.size
  end
  
end
