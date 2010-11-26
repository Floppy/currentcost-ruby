require 'observer'

module CurrentCost

  # A helper class for RB232::Port which implements a simple text-based
  # protocol on top of a serial port. Data is read from the serial port and split
  # into individual messages based on a separator character.
  #
  # This class is Observable. Client code should implement an update(string) function
  # add call TextProtocol#add_observer(self). When a complete message is received,
  # the update() function will be called with the message string.  
  class TextProtocol

    include Observable

    # Create a protocol object. _port_ should be a RB232::Port object.
    # _separator_ is the character which separates messages in the text protocol,
    # "\n" by default.
    def initialize(port, separator = "\n")
      @port = port
      @separator = separator
    end

    # Separator character, as specified in TextProtocol#new
    attr_reader :separator

    # Port object, as specified in TextProtocol#new
    attr_reader :port

    # Begin processing incoming data from the serial port.
    # A thread is started which monitors the port for data and detects
    # complete messages.
    # Call TextProtocol#stop to halt this process.
    def start
      @stop = false
      @reader_thread = Thread.new {
        begin
          message = @port.gets(@separator)
          changed
          notify_observers(message)
        end while (@stop == false)
      }
    end

    # Stop processing incoming data from the serial port.
    def stop
      @stop = true
      @reader_thread.join
    end

  end

end
