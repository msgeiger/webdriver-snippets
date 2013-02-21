#!/usr/bin/env ruby
# ruby set_build_variables.rb -v 'IE7' -s 'http://some_hub/wd/hub' -u 'https://some_url.com' -t 60
require 'optparse'
options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: example.rb [options]"

  opts.on("-v", "--version", "browser version") do |v|
    options[:version] = v
  end

  opts.on("-s", "--selHost", "selenium Host") do |s|
    options[:selHost] = s
  end

  opts.on("-u", "--selUrl", "selenium Port") do |u|
    options[:selURL] = u
  end

  opts.on("-t", "--selTimeout", "selenium Timeout") do |t|
    options[:selTimeout] = t
  end

  opts.on("-b", "--browser", "selenium Browser") do |b|
    options[:browser] = b
  end

  opts.on("-h", "--help", "Help >> switch config (required) parameters: ruby set_build_variables.rb -v <version> -s <host> -u <url> -t <set timeout> -b <browser>") do
    puts opts; exit
  end

end.parse!

version    = (options[:version]    == true && ARGV[0] != nil) ? ARGV[0] : 'IE7'
selHost    = (options[:selHost]    == true && ARGV[1] != nil) ? ARGV[1] : 'http://some_hub.com:5055/wd/hub'
selURL     = (options[:selURL]     == true && ARGV[2] != nil) ? ARGV[2] : 'https://some_url.com'
selTimeout = (options[:selTimeout] == true && ARGV[3] != nil) ? ARGV[3] : 60
browser    = (options[:browser]    == true && ARGV[4] != nil) ? ARGV[4] : '*iexplore'

configValues = [ "WDVERSION = '#{version}'", 
  "WDHOST = '#{selHost}'", 
  "WDURL = '#{selURL}'", 
  "WDTIMEOUT = '#{selTimeout}'", 
  "WDBROWSER = '#{browser}'" ]

f = File.open('./build_config.rb', 'w')

configValues.each do |line|
    f.write(line+"\n")
end

f.close
