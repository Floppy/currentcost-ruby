Gem::Specification.new do |s|
  s.name = "currentcost"
  s.version = "0.1.2"
  s.date = "2008-08-20"
  s.summary = "Ruby interface to the CurrentCost energy meter"
  s.email = "james@floppy.org.uk"
  s.homepage = "http://github.com/Floppy/currentcost-ruby"
  s.has_rdoc = true
  s.authors = ["James Smith"]
  s.files = ["README", "COPYING"]
  s.files += ["lib/currentcost.rb", "lib/currentcost/meter.rb", "lib/currentcost/reading.rb", "lib/currentcost/version.rb", "lib/currentcost/exceptions.rb"]
  s.files += ["examples/simple.rb"]
  s.add_dependency('Floppy-rb232', [">= 0.1.0"])
end