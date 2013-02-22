require File.dirname(__FILE__) + '/../build_config.rb'
require File.dirname(__FILE__) + '/../test_unit_config.rb'

# Instantiate custom Geiger handler
class TestLinks < Geiger 
  def test_links
    driver = self.get_driver
    wait = self.get_wait
    testing_url = 'http://www.marinebay.com'

    url = [
      "#{testing_url}/browse/boats",
      "#{testing_url}/browse/boatengines",
      "#{testing_url}/browse/trailers"
    ]
   
   ids = [
     {:id => "title_navigation"},
     {:id => "main_title"}
   ]

    url.each do |page|
      driver.navigate.to page 
      ids.each do |element|
        self.wait_for_element element 
        puts element
      end
    end
  end
end
