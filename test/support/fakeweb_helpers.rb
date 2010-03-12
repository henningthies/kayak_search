#test/support/fakeweb_helper.rb
require File.expand_path(RAILS_ROOT + '/test/fixtures/fakeweb_urls')
 
#taken from http://bit.ly/coZDQw
module FakewebHelpers  
 
## Constants
 
# Make sure nothing gets out (IMPORTANT)  
FakeWeb.allow_net_connect = false  
 
   # Turns a fixture file name into a full path  
   def fixture_file(filename)  
     return '' if filename == ''  
     ERB.new(File.read(File.expand_path(RAILS_ROOT + '/test/fixtures/' + filename))).result(binding)
   end  
   
   # Convenience methods for stubbing URLs to fixtures  
   def stub_get(url, filename)  
     FakeWeb.register_uri(:get, url, :response => fixture_file(filename))  
   end                                                              
                                                                    
   def stub_post(url, filename)                                     
     FakeWeb.register_uri(:post, url, :response => fixture_file(filename))  
   end                                                              
 
   def stub_any(url, filename)                                      
     FakeWeb.register_uri(:any, url, :response => fixture_file(filename))  
   end  
   
end