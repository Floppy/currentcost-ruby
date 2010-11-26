Gem::Specification.new do |s|
  s.name = "currentcost"
  s.version = "0.3.4"
  s.date = "2009-11-15"
  s.summary = "Ruby interface to the CurrentCost energy meter"
  s.email = "james@floppy.org.uk"
  s.homepage = "http://github.com/Floppy/currentcost-ruby"
  s.has_rdoc = true
  s.authors = ["James Smith"]
  s.files = ["README", "COPYING"]
  s.files += ["lib/currentcost.rb", "lib/currentcost/meter.rb", "lib/currentcost/reading.rb", "lib/currentcost/version.rb", "lib/currentcost/exceptions.rb", "lib/currentcost/text_protocol.rb"]
  s.files += ["examples/simple.rb"]
  s.files += ["bin/currentcost_tray_monitor.rb"]
  s.executables = ['currentcost_tray_monitor.rb']
  s.add_dependency('serialport', [">= 1.0.4"])
end
