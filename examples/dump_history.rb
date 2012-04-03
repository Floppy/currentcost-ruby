#!/usr/bin/env ruby

dir = File.dirname(__FILE__) + '/../lib'
$LOAD_PATH << dir unless $LOAD_PATH.include?(dir)

require 'rubygems'
require 'currentcost/meter'

require 'optparse'

# Instructions!
puts "Hold down the DOWN and OK buttons for a few seconds, then release..."

# Command-line options
options = {:port => '/dev/ttyS0'}
OptionParser.new do |opts|
  opts.on("-p", "--serial_port SERIAL_PORT", "serial port") do |p|
    options[:port] = p
  end  
end.parse!

# A simple observer class which will receive updates from the meter
class HistoryObserver
  def update(xml)
    if xml.include?('<hist>')
      puts xml
      $stdout.flush
    end
  end
end

# Create meter
meter = CurrentCost::Meter.new(options[:port], :cc128 => true)
# Create observer
observer = HistoryObserver.new
# Register observer with meter
meter.protocol.add_observer(observer)
# Wait a while, let things happen
sleep(60)
# Close the meter object to stop it receiving data
meter.close
