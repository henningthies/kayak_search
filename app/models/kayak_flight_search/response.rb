class KayakFlightSearch::Response
 
  attr_reader :search_id
  attr_reader :count
  attr_reader :more_pending
  attr_reader :trips
  
  def initialize (doc)
    
    root = doc.xpath('/searchresult').first
    
    @search_id = root.xpath('searchid').first.content
    @count = root.xpath('count').first.content.to_i
    @more_pending = root.xpath('morepending').first.content
    @more_pending ||= "false"
    
    @trips = []
    root.xpath('trips/trip').each do |trip|
      @trips << KayakFlightSearch::Trip.new(trip)
    end
    
  end
  
  def more_pending=(more_pending)
    @more_pending = more_pending
  end
  
end