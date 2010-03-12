require 'test_helper'

class FlightsControllerTest < ActionController::TestCase
  
  def setup
    @flight = Flight.first
    @cache = ActiveSupport::Cache.lookup_store(:file_store , RAILS_ROOT+"/tmp/cache")
    
    @flight.kayak_request.xml = File.open(RAILS_ROOT+"/tmp/test.xml").read
    @flight.kayak_request.save
    
    stub_get(FakewebUrls::SID, "fakeweb_sid.response")
    stub_get(FakewebUrls::SEARCHID, "fakeweb_searchid.response")
    FakeWeb.register_uri(:get, FakewebUrls::XMLFIRST, [
      {:body => fixture_file("fakeweb_xmlfirst.response"), :status => ["200", "OK"]}, 
      {:body => fixture_file("fakeweb_xmlsecond.response"), :status => ["200", "OK"]}      
      ])
    stub_get(FakewebUrls::XMLALL, "fakeweb_xmlall.response")
    stub_get(FakewebUrls::GEOHAM, "fakeweb_geoham.response")
    stub_get(FakewebUrls::GEOLHR, "fakeweb_geolhr.response")
  end
  
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:flights)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create flight" do
    assert_difference('Flight.count') do
      post :create, :flight => {:origin => "Hamburg", :destination => "London", :depart_date => "2010-04-02" }
    end

    assert_redirected_to flight_path(assigns(:flight))
  end

  test "should show flight" do
    get :show, :id => @flight.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @flight.to_param
    assert_response :success
  end

  test "should update flight" do
    put :update, :id => @flight.to_param, :flight => { }
    assert_redirected_to flight_path(assigns(:flight))
  end

  test "should destroy flight" do
    assert_difference('Flight.count', -1) do
      delete :destroy, :id => @flight.to_param
    end
    assert_redirected_to flights_path
  end

  def test_should_cache_show_action
    @cache.delete("views/test.host/flights/#{@flight.id}") if @cache.exist?("views/test.host/flights/#{@flight.id}")
    get :show, :id => @flight.to_param
    assert_tag(:tag => 'li')
    assert @cache.exist?("views/test.host/flights/#{@flight.id}")
  end
  
  def test_should_add_reload_to_cache
    @cache.delete("views/test.host/flights/#{@flight.id}") if @cache.exist?("views/test.host/flights/#{@flight.id}")
    @flight.kayak_request.touch
    @flight.kayak_request.more_pending = "false"
    @flight.kayak_request.save

    get :show, :id => @flight.to_param
    assert_no_tag :tag => "li", :descendant => { :tag => "script" }
    
    Timecop.freeze(Date.today + 30) do
      get :show, :id => @flight.to_param
      assert_tag :tag => "li", :descendant => { :tag => "script" }
    end
  end

  def test_should_spawn_request
    controller = FlightsController.new
    kayak_search = KayakSearch.new(@flight)
    controller.send(:make_request, kayak_search, @flight, "test.host")
    assert_equal "true", @flight.kayak_request.more_pending
    controller.send(:make_request, kayak_search,@flight, "test.host")
    assert_equal "false", @flight.kayak_request.more_pending
  end
  
  def test_should_render_periodically_call_remote
    @cache.delete("views/test.host/flights/#{@flight.id}") if @cache.exist?("views/test.host/flights/#{@flight.id}")
    @flight.kayak_request.touch
    @flight.kayak_request.more_pending = "true"
    @flight.kayak_request.save
    get :show, :id => @flight.to_param
    assert_tag :tag => "li", :descendant => { :tag => "script" }
  end
  
  
end
