# test/fixtures/fakeweb_urls.rb
 
module FakewebUrls
  
  GEOHAM = 'http://maps.google.com/maps/geo?q=Hamburg&output=xml&key=REPLACE_WITH_YOUR_GOOGLE_KEY&oe=utf-8'
  GEOLHR = 'http://maps.google.com/maps/geo?q=London&output=xml&key=REPLACE_WITH_YOUR_GOOGLE_KEY&oe=utf-8'
  
  SID = 'http://api.kayak.com/k/ident/apisession?token=bAfqq0x4X6HD4$GFD8QMkQ'
  SEARCHID = 'http://api.kayak.com/s/apisearch?basicmode=true&oneway=n&origin=HAM&destination=LCY&depart_date=04-01-2010&depart_time=a&&return_date=04-08-2010&return_time=a&travelers=2&cabin=e&&nearbyO=1&nearbyD=1&action=doflights&apimode=1&_sid_=27-MZEBH9pIH3djH0xMRDLl'
  XMLFIRST = 'http://api.kayak.com/s/apibasic/flight?searchid=SzzO3S&s=price&c=10&apimode=1&_sid_=27-MZEBH9pIH3djH0xMRDLl'
  XMLALL = 'http://api.kayak.com/s/apibasic/flight?searchid=SzzO3S&s=price&c=15&apimode=1&_sid_=27-MZEBH9pIH3djH0xMRDLl'
  BUZZ = 'http://api.kayak.com/h/rss/buzz?code=HAM&mc=EUR'
  FARE = 'http://api.kayak.com/h/rss/fare?code=HAM&dest=LCY&mc=EUR'
end