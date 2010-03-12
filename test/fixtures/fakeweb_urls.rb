# test/fixtures/fakeweb_urls.rb
 
module FakewebUrls
  
  GEOHAM = 'http://maps.google.com/maps/geo?q=Hamburg&output=xml&key=REPLACE_WITH_YOUR_GOOGLE_KEY&oe=utf-8'
  GEOLHR = 'http://maps.google.com/maps/geo?q=London&output=xml&key=REPLACE_WITH_YOUR_GOOGLE_KEY&oe=utf-8'
  
  SID = 'http://api.kayak.com/k/ident/apisession?token=bAfqq0x4X6HD4$GFD8QMkQ'
  SEARCHID = 'http://api.kayak.com/s/apisearch?basicmode=true&oneway=y&origin=HAM&destination=LHR&destcode=&depart_date=04-02-2010&depart_time=a&travelers=1&cabin=e&action=doflights&apimode=1&_sid_=27-MZEBH9pIH3djH0xMRDLl&nearbyO=1&nearbyD=1'
  XMLFIRST = 'http://api.kayak.com/s/apibasic/flight?searchid=SzzO3S&s=price&apimode=1&_sid_=27-MZEBH9pIH3djH0xMRDLl'
  XMLALL = 'http://api.kayak.com/s/apibasic/flight?searchid=SzzO3S&s=price&c=15&apimode=1&_sid_=27-MZEBH9pIH3djH0xMRDLl'
  
end