require 'test_helper'

class AirportTest < ActiveSupport::TestCase
  
  should_validate_uniqueness_of :airportid
  should_validate_presence_of :airportid
  should_validate_numericality_of :airportid
  
  should_validate_presence_of :name
  should_validate_presence_of :lat
  should_validate_presence_of :lng  
  
end
