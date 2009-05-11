require 'rb232'
require 'rb232/text_protocol'
require 'currentcost/meter'
require 'currentcost/reading'
require 'observer'

module CurrentCost

  # A class to represent a physical CurrentCost meter attached to a serial port.
  # This class is Observable (see Ruby documentation for details). Client code
  # should create an observer class which defines an update(CurrentCost::Reading)
  # function, and call Meter.add_observer(my_observer) to receive updates when
  # new readings are received from the physical meter.
  # 
  # For example:
  #
  #   require 'currentcost/meter'
  #
  #   class SimpleObserver
  #     def update(reading)
  #       puts "New reading received: #{reading.channels[0][:watts]} W"
  #     end
  #   end
  # 
  #   meter = CurrentCost::Meter.new(:cc128 => true)
  #   observer = SimpleObserver.new
  #   meter.add_observer(observer)
  #   sleep(30) # wait a while, let some readings come in
  #   meter.close

  
  class Meter

    include Observable

    # Constructor. 'port' is the name of the serial port that the physical
    # meter is connected to.
    # Connection is to a classic meter by default. To connect to a new-stlye
    # CC128, pass :cc128 => true at the end
    # This function will automatically start processing serial data on the
    # specified port. To stop this processing, call close.
    def initialize(port = '/dev/ttyS0', options = {})
      @port = RB232::Port.new(port, :baud_rate => (options[:cc128] == true ? 57600 : 9600), :data_bits => 8, :stop_bits => 1, :parity => false)
      @protocol = RB232::TextProtocol.new(@port, "\n")
      @protocol.add_observer(self)
      @protocol.start
    end

    # Internal use only, client code does not need to use this function. Informs
    # the Meter object that a new message has been received by the serial port. 
    def update(message)
      unless message.nil?
        # Parse reading from message
        @latest_reading = Reading.from_xml(message)
        # Inform observers
        changed
        notify_observers(@latest_reading)
      end
    rescue CurrentCost::ParseError
      nil
    end

    # Get the last Reading received. If no reading has been received yet,
    # returns nil. If you have registered an observer with add_observer(),
    # you will most likely not need this function as the reading will be
    # delivered automatically to your observer's update() function.
    def latest_reading
      @latest_reading
    end

    # Stops serial data processing. Call this once you're done with the Meter
    # object.
    def close
      @protocol.stop
    end

  end
  
end