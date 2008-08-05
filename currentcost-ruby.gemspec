Gem::Specification.new do |s|
  s.name = "currentcost"
  s.version = "0.0.1"
  s.date = "2008-08-05"
  s.summary = "Ruby interface to the CurrentCost energy meter"
  s.email = "james@floppy.org.uk"
  s.homepage = "http://github.com/Floppy/currentcost-ruby"
  s.has_rdoc = false
  s.authors = ["James Smith"]
  s.files = ["README", "COPYING"]
  s.files += ["lib/currentcost.rb", "lib/currentcost/meter.rb", "lib/currentcost/reading.rb"]
  s.files += ['bin/test_currentcost.rb']
  s.add_dependency('ruby-serialport', [">= 0.7.0"])
end