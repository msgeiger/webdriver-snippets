module Dispatcher
  def initialize(browser, version, host, timeout, url) 
    case browser
      when '*iexplore'
        caps = Selenium::WebDriver::Remote::Capabilities.internet_explorer(
          :javascript_enabled => false, 
          :version => version)
        @wd_driver = Selenium::WebDriver.for(
          :remote, :url => host, 
          :desired_capabilities => caps)
        @wd_wait = Selenium::WebDriver::Wait.new :timeout => timeout 
        @wd_url = url 
      when 'firefox'
        caps = Selenium::WebDriver::Remote::Capabilities.firefox(
          :javascript_enabled => true, 
          :version => version)
        @wd_driver = Selenium::WebDriver.for(
          :remote, :url => host, 
          :desired_capabilities => caps)
        @wd_wait = Selenium::WebDriver::Wait.new :timeout => timeout 
        @wd_url = url 
    end
  end

  def wd_driver
    @wd_driver
  end

  def wd_wait
    @wd_wait
  end

  def wd_url
    @wd_url
  end
end

class WDSetup 
  include Dispatcher
end
