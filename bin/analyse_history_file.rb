require 'rubygems'
require 'active_support'
require 'currentcost'

def merge_sensor_data(source, target, sensor_id)
  return unless source
  source.each_with_index do |s,i|
    if s && s[sensor_id]
      target[i] ||= s[sensor_id]
    end
  end
end

time = DateTime.parse ARGV[1]

File.open ARGV[0] do |f|
  days = []
  hours = []
  f.each_line do |line|
      r = CurrentCost::Reading.from_xml(line)
      merge_sensor_data(r.history[:days], days, 0)
      merge_sensor_data(r.history[:hours], hours, 0)
  end

  # Write CSV file
  File.open "days.csv", "w" do |csv|
    days.each_with_index do |day, i|
      if day
        csv << time.to_date - i.days << ',' << day << "\n"
      end
    end
  end

  # Write CSV file
  File.open "hours.csv", "w" do |csv|
    hours.each_with_index do |hour, i|
      if hour
        csv << time - i.hours << ',' << hour << "\n"
      end
    end
  end

end