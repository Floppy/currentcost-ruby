require 'currentcost/exceptions'
require 'rexml/document'

module CurrentCost
  
  class Reading
    
    def self.from_xml(xml)
      # Parse XML
      doc = REXML::Document.new(xml)
      # Create reading object
      r = Reading.new
      # Extract basic data
      r.days_since_birth = REXML::XPath.first(doc, "/msg/date/dsb").text.to_i
      r.hour = REXML::XPath.first(doc, "/msg/date/hr").text.to_i
      r.minute = REXML::XPath.first(doc, "/msg/date/min").text.to_i
      r.second = REXML::XPath.first(doc, "/msg/date/sec").text.to_i
      r.name = REXML::XPath.first(doc, "/msg/src/name").text
      r.id = REXML::XPath.first(doc, "/msg/src/id").text
      r.type = REXML::XPath.first(doc, "/msg/src/type").text
      r.software_version = REXML::XPath.first(doc, "/msg/src/sver").text
      r.temperature = REXML::XPath.first(doc, "/msg/tmpr").text.to_f
      r.channels = []
      REXML::XPath.each(doc, "/msg/*/watts") do |node|
        r.channels << { :watts => node.text.to_i }
      end
      # Extract history data
      if REXML::XPath.first(doc, "/msg/hist")
        r.history = {}
        r.history[:hours] = []
        REXML::XPath.each(doc, "/msg/hist/hrs/*") do |node|
          r.history[:hours][node.name.slice(1,2).to_i] = node.text.to_f
        end
        r.history[:days] = []
        REXML::XPath.each(doc, "/msg/hist/days/*") do |node|
          r.history[:days][node.name.slice(1,2).to_i] = node.text.to_i
        end
        r.history[:months] = []
        REXML::XPath.each(doc, "/msg/hist/mths/*") do |node|
          r.history[:months][node.name.slice(1,2).to_i] = node.text.to_i
        end
        r.history[:years] = []
        REXML::XPath.each(doc, "/msg/hist/yrs/*") do |node|
          r.history[:years][node.name.slice(1,2).to_i] = node.text.to_i
        end
      end
      # Done
      return r
    rescue 
      raise CurrentCost::ParseError.new("Couldn't parse XML data.")
    end
    
    attr_accessor :days_since_birth
    attr_accessor :hour
    attr_accessor :minute
    attr_accessor :second
    attr_accessor :name
    attr_accessor :id
    attr_accessor :type
    attr_accessor :software_version
    attr_accessor :channels
    attr_accessor :temperature
    attr_accessor :history
    
  end
  
end
