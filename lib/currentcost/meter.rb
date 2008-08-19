require 'rb232'
require 'rb232/text_protocol'
require 'currentcost/reading'

module CurrentCost
  
  class Meter
    
    def initialize(port = '/dev/ttyS0')
      @port = RB232::Port.new(port, :baud_rate => 9600)
      @protocol = RB232::TextProtocol.new(@port, "\n")
      @protocol.add_observer(self)
      @protocol.start
    end

    def update(message)
      @latest_reading = Reading.from_xml(message) unless message.nil?
    rescue CurrentCost::ParseError
      nil
    end

    def latest_reading
      @latest_reading
    end

    def close
      @protocol.stop
    end

  end
  
end