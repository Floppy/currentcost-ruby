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

# A simple observer class which will receive updates from the meter
class SimpleObserver
  def update(reading)
    # Add all channels to get real figure
    watts = 0 
    reading.channels.each { |c| watts += c[:watts] }
    # Print out measurement
    puts "New reading received: #{watts} W"
  end
end

# Create meter
meter = CurrentCost::Meter.new(options[:port])
# Create observer
observer = SimpleObserver.new
# Register observer with meter
meter.add_observer(observer)
# Wait a while, let some readings come in
sleep(30)
# Close the meter object to stop it receiving data
meter.close