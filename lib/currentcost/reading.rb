require 'currentcost/exceptions'
require 'rexml/document'

module CurrentCost
  
  class Reading

    # Creates a reading object from an XML string.
    # Raises CurrentCost::ParseError if the XML is malformed or missing
    # expected content.
    def self.from_xml(xml)
      # Parse XML
      doc = REXML::Document.new(xml)
      # Create reading object
      r = Reading.new
      # Check version
      r.software_version = REXML::XPath.first(doc, "/msg/src/sver").text rescue nil
      if r.software_version.nil?
        r.software_version = REXML::XPath.first(doc, "/msg/src").text
      end
      # Extract basic data
      if r.software_version.include? "CC128"
        r.days_since_birth = REXML::XPath.first(doc, "/msg/dsb").text.to_i
        r.hour, r.minute, r.second = REXML::XPath.first(doc, "/msg/time").text.split(':').map{|x| x.to_i}
        r.id = REXML::XPath.first(doc, "/msg/id").text rescue nil
        r.type = REXML::XPath.first(doc, "/msg/type").text rescue nil
        r.temperature = REXML::XPath.first(doc, "/msg/tmpr").text.to_f rescue nil
        r.sensor = REXML::XPath.first(doc, "/msg/sensor").text rescue nil
        # Extract history data
        if REXML::XPath.first(doc, "/msg/hist")
          r.history = {}
          REXML::XPath.each(doc, "/msg/hist/data") do |sensor|
            sensor_num = sensor.elements['sensor'].text.to_i
            sensor.elements.each do |item|
              match = item.name.match "([hdm])([0-9][0-9][0-9])"
              if match
                case match[1]
                when 'h'
                  type = :hours
                when 'd'
                  type = :days
                when 'm'
                  type = :months
                end
                r.history[type] ||= []
                r.history[type][match[2].to_i] ||= []
                r.history[type][match[2].to_i][sensor_num] = item.text.to_f
              end
            end
          end
        end
      else
        r.days_since_birth = REXML::XPath.first(doc, "/msg/date/dsb").text.to_i
        r.hour = REXML::XPath.first(doc, "/msg/date/hr").text.to_i
        r.minute = REXML::XPath.first(doc, "/msg/date/min").text.to_i
        r.second = REXML::XPath.first(doc, "/msg/date/sec").text.to_i
        r.name = REXML::XPath.first(doc, "/msg/src/name").text
        r.id = REXML::XPath.first(doc, "/msg/src/id").text
        r.type = REXML::XPath.first(doc, "/msg/src/type").text
        r.temperature = REXML::XPath.first(doc, "/msg/tmpr").text.to_f
        # Extract history data
        if REXML::XPath.first(doc, "/msg/hist")
          r.history = {}
          r.history[:hours] = []
          REXML::XPath.each(doc, "/msg/hist/hrs/*") do |node|
            r.history[:hours][node.name.slice(1,2).to_i] = [node.text.to_f]
          end
          r.history[:days] = []
          REXML::XPath.each(doc, "/msg/hist/days/*") do |node|
            r.history[:days][node.name.slice(1,2).to_i] = [node.text.to_i]
          end
          r.history[:months] = []
          REXML::XPath.each(doc, "/msg/hist/mths/*") do |node|
            r.history[:months][node.name.slice(1,2).to_i] = [node.text.to_i]
          end
          r.history[:years] = []
          REXML::XPath.each(doc, "/msg/hist/yrs/*") do |node|
            r.history[:years][node.name.slice(1,2).to_i] = [node.text.to_i]
          end
        end
      end
      # Common information
      r.channels = []
      REXML::XPath.each(doc, "/msg/*/watts") do |node|
        r.channels << { :watts => node.text.to_i }
      end
      # Done
      return r
    rescue
      raise CurrentCost::ParseError.new("Couldn't parse XML data.")
    end

    # Number of days since the meter was turned on
    attr_accessor :days_since_birth
    # Current time - hour
    attr_accessor :hour
    # Current time - minute
    attr_accessor :minute
    # Current time - second
    attr_accessor :second
    # Name of the device - always "CC02".
    attr_accessor :name
    # ID number of the device
    attr_accessor :id
    # Type id of the device - "1" for a standard CurrentCost meter.
    attr_accessor :type
    # Version of the meter software
    attr_accessor :software_version
    # An array of channels. channels[x][:watts] contains the current power for that channel in watts. The figure shown on the meter is the sum of the wattage for all channels.
    attr_accessor :channels
    # Current temperature
    attr_accessor :temperature
    # Sensor number
    attr_accessor :sensor
    # Historical data, represented as a hash. There is a hash entry for days, weeks, months, and years. Each of these is an array of sensors, each of which contains an array of historical kWh data.
    attr_accessor :history

    # The sum of the current wattage for all channels, as shown on the meter
    def total_watts
      watts = 0
      channels.each { |c| watts += c[:watts] }
      return watts
    rescue
      0
    end

  end

end