require 'test_helper'

class KayakSearchTest < ActiveSupport::TestCase

  def setup
    stub_get(FakewebUrls::GEOHAM, "fakeweb_geoham.response")
    stub_get(FakewebUrls::GEOLHR, "fakeweb_geolhr.response")
    stub_get(FakewebUrls::SID, "fakeweb_sid.response")
    stub_get(FakewebUrls::SEARCHID, "fakeweb_searchid.response")    
    FakeWeb.register_uri(:get, FakewebUrls::XMLFIRST, [
      {:body => fixture_file("fakeweb_xmlfirst.response"), :status => ["200", "OK"]}, 
      {:body => fixture_file("fakeweb_xmlsecond.response"), :status => ["200", "OK"]}      
      ])
    stub_get(FakewebUrls::XMLALL, "fakeweb_xmlall.response")
    
    @kayak = KayakSearch.new(flights(:ham_lhr))
  end

  def test_should_have_api_key
    assert_not_nil ENV['KAYAK_API_KEY']
  end
  
  def test_should_get_session_id
    assert_equal "27-MZEBH9pIH3djH0xMRDLl", @kayak.sid
  end
  
  def test_should_get_search_id
    assert_equal "SzzO3S", @kayak.search_id
  end
  
  def test_should_get_xml
    count, more_pending, xml = @kayak.get_xml
    assert_equal 9, count
    assert_equal "true", more_pending
    count, more_pending, xml = @kayak.get_xml
    assert_equal 15, count
    assert_equal "false", more_pending
  end
  
  
  
end
