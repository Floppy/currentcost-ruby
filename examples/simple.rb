#!/usr/bin/env ruby

dir = File.dirname(__FILE__) + '/../lib'
$LOAD_PATH << dir unless $LOAD_PATH.include?(dir)

require 'rubygems'
require 'currentcost/meter'

require 'optparse'

# Command-line options
options = {:port => '/dev/ttyS0'}
OptionParser.new do |opts|
  opts.on("-p", "--serial_port SERIAL_PORT", "serial port") do |p|
    options[:port] = p
  end  
end.parse!

# Create meter
meter = CurrentCost::Meter.new(options[:port])

while true
  reading = meter.latest_reading
  if reading
    puts "#{reading.channels[0][:watts]}W"
  end
  sleep(6)
end