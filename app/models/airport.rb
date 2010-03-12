class Airport < ActiveRecord::Base
  acts_as_mappable
  
  #before_validation_on_create :geocode_address
  
  validates_presence_of :airportid
  validates_numericality_of :airportid
  validates_uniqueness_of :airportid

  validates_presence_of :name
  validates_presence_of :lat
  validates_presence_of :lng
  
    
  private 
  def geocode_address
    address = "#{self.location}" 
    geo = Geokit::Geocoders::MultiGeocoder.geocode(address)
    errors.add(address, "Could not Geocode address") if !geo.success
    self.lat, self.lng = geo.lat, geo.lng if geo.success
    puts "#{self.lat}, #{self.lng}"
  end
  
end
