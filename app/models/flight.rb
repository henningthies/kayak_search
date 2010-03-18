require 'net/http'
require 'open-uri'
require 'kayak_flight_search.rb'

class Flight < ActiveRecord::Base
  serialize :kayak_search_response
  
  validates_presence_of :origin
  validates_presence_of :destination
  validates_presence_of :depart_date
  validates_presence_of :return_date
  
  validates_presence_of :departure_airport, :message => "Could not GeoCode origin"
  validates_presence_of :arrival_airport, :message => "Could not GeoCode destination"
  
  belongs_to :departure_airport, :class_name => "Airport"
  belongs_to :arrival_airport, :class_name => "Airport"
  
  has_one :kayak_rss, :dependent => :destroy
  
  before_validation_on_create :find_airports, :find_dates
    
  def cache_key
    "kayak_requests/#{self.id}" 
  end
  
  private
  
  def find_airports
    address = "#{self.origin}" 
    geo = Geokit::Geocoders::GoogleGeocoder.geocode(address)  
    self.departure_airport = Airport.find(:first, :origin =>[geo.lat,geo.lng], :within => 200, :order => "distance asc", :conditions =>  ["airports.incommings > 10 AND airports.outgoings > 10"]) if geo.success
    address = "#{self.destination}" 
    geo = Geokit::Geocoders::GoogleGeocoder.geocode(address)
    self.arrival_airport = Airport.find(:first, :origin =>[geo.lat,geo.lng], :within => 200, :order => "distance asc", :conditions =>  ["airports.incommings > 10 AND airports.outgoings > 10"]) if geo.success
  end
  
  def find_dates
    d = Date.today
    self.depart_date = d.beginning_of_month.next_month
    self.return_date = d.beginning_of_month.next_month + 7.days
  end


end
