require File.dirname(__FILE__) + '/spec_helper.rb'

TEST_PORT = "/dev/ttyUSB0"

describe CurrentCost::Meter do
  
  before(:each) do    
    @meter = CurrentCost::Meter.new(TEST_PORT)
  end
  
  after(:each) do
    @meter.close
  end

  it "should allow access to the latest reading" do
    @meter.latest_reading.is_a?(CurrentCost::Reading).should be_true
  end
  
  it "should be an Observer" do
    @meter.should respond_to(:update)
  end

end
