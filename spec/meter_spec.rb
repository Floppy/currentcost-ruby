require File.dirname(__FILE__) + '/spec_helper.rb'

describe CurrentCost::Meter do
  
  before(:each) do
    @meter = CurrentCost::Meter.new
  end
  
  it "should allow access to the latest reading" do
    @meter.latest_reading.is_a?(CurrentCost::Reading).should be_true
  end
  
end