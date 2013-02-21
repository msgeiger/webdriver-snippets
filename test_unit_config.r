require 'rubygems'
ENV['BUNDLE_GEMFILE'] = File.expand_path(File.join(File.dirname(__FILE__), '/Gemfile'))
require 'bundler/setup'
require 'selenium-webdriver'
require 'test/unit'
require 'ci/reporter/rake/test_unit_loader.rb'
require File.dirname(__FILE__) + '/wdsetup.rb'
require File.dirname(__FILE__) + '/snippets.rb'

class Datanex < Test::Unit::TestCase
  def setup
    #require File.dirname(__FILE__) + '/build_config.rb'
    dispatcher = WDSetup.new(WDBROWSER, WDVERSION, WDHOST, WDTIMEOUT, WDURL)
    @wd_driver = dispatcher.wd_driver 
    @wd_wait = dispatcher.wd_wait
    @wd_url = dispatcher.wd_url 
  end

  def teardown
    @wd_driver.quit
  end

  def get_driver
    @wd_driver
  end

  def get_wait
    @wd_wait
  end

  def get_url
    @wd_url
  end

  include Snippets
end
