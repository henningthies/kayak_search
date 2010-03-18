require 'test_helper'

class KayakFlightSearchTest < ActiveSupport::TestCase
  
  def setup
    stub_get(FakewebUrls::SID, "fakeweb_sid.response")
    stub_get(FakewebUrls::SEARCHID, "fakeweb_searchid.response")  
    FakeWeb.register_uri(:get, FakewebUrls::XMLFIRST, [
      {:body => fixture_file("fakeweb_xmlfirst.response"), :status => ["200", "OK"]}, 
      {:body => fixture_file("fakeweb_xmlsecond.response"), :status => ["200", "OK"]}      
      ])
    stub_get(FakewebUrls::XMLALL, "fakeweb_xmlall.response") 
    @kayak_flight_search = KayakFlightSearch::Client.new
    @result = @kayak_flight_search.lookup(:depart_airport => "HAM", :arrival_airport => "LCY")
  end
  
  def test_should_get_session_id
    assert_equal "27-MZEBH9pIH3djH0xMRDLl", @kayak_flight_search.session_id
  end
  
  def test_should_get_search_id
    assert_equal "SzzO3S", @kayak_flight_search.search_id
  end
  
  def test_should_return_response_object
    assert_instance_of KayakFlightSearch::Result, @result
    assert_instance_of KayakFlightSearch::Response, @result.get_results   
  end
  
  def test_should_have_trips
    assert_instance_of Array, @result.response.trips 
    assert_equal @result.response.count, @result.response.trips.size
  end
  
  def test_should_have_many_trips
    assert_instance_of KayakFlightSearch::Trip, @result.response.trips.first
  end
  
  def test_should_have_legs
    assert_instance_of Array, @result.response.trips[0].legs
    assert_equal 1, @result.response.trips[0].legs.size
    assert_instance_of KayakFlightSearch::Leg, @result.response.trips[0].legs.first
  end
  
  def test_should_refresh_response
    assert_equal "true", @result.response.more_pending
    assert_not_equal @result.response, @result.get_results
    assert_equal "false",  @result.get_results.more_pending
  end

end