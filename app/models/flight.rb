class Flight < ActiveRecord::Base
  validates_presence_of :origin
  validates_presence_of :destination
  validates_presence_of :depart_date
  
  validates_presence_of :departure_airport, :message => "Could not GeoCode origin"
  validates_presence_of :arrival_airport, :message => "Could not GeoCode destination"
  
  belongs_to :departure_airport, :class_name => "Airport"
  belongs_to :arrival_airport, :class_name => "Airport"
  
  has_one :kayak_request, :dependent => :destroy
  
  before_validation_on_create :find_airports
  
  private
  
  def find_airports
    address = "#{self.origin}" 
    geo = Geokit::Geocoders::GoogleGeocoder.geocode(address)  
    self.departure_airport = Airport.find(:first, :origin =>[geo.lat,geo.lng], :within => 200, :order => "distance asc", :conditions =>  ["airports.incommings > 1 AND airports.outgoings > 1"]) if geo.success
    address = "#{self.destination}" 
    geo = Geokit::Geocoders::GoogleGeocoder.geocode(address)
    self.arrival_airport = Airport.find(:first, :origin =>[geo.lat,geo.lng], :within => 200, :order => "distance asc", :conditions =>  ["airports.incommings > 1 AND airports.outgoings > 1"]) if geo.success
  end
  
end
