class KayakFlightSearch::Segment
 
  attr_reader :airline
  attr_reader :flight
  attr_reader :duration
  attr_reader :equip
  attr_reader :miles
  attr_reader :origin
  attr_reader :destination
  attr_reader :depart
  attr_reader :arrive
  attr_reader :cabin
  
  def initialize (segment)    
    @airline = segment.xpath('airline').first.text
    @flight = segment.xpath('flight').first.text
    @duration = segment.xpath('duration_minutes').first.text
    @equip = segment.xpath('equip').first.text
    @miles = segment.xpath('miles').first.text
    @origin = segment.xpath('o').first.text
    @destination = segment.xpath('d').first.text
    @depart = segment.xpath('dt').first.text
    @arrive = segment.xpath('at').first.text
    @cabin = segment.xpath('cabin').first.text
  end
  
end