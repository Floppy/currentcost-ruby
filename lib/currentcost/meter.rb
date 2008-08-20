require 'rb232'
require 'rb232/text_protocol'
require 'currentcost/reading'
require 'observer'

module CurrentCost
  
  class Meter

    include Observable

    def initialize(port = '/dev/ttyS0')
      @port = RB232::Port.new(port, :baud_rate => 9600)
      @protocol = RB232::TextProtocol.new(@port, "\n")
      @protocol.add_observer(self)
      @protocol.start
    end

    def update(message)
      # Parse reading from message
      @latest_reading = Reading.from_xml(message) unless message.nil?
      # Inform observers
      changed
      notify_observers(@latest_reading)
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