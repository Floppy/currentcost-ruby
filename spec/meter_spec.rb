require File.dirname(__FILE__) + '/spec_helper.rb'

TEST_PORT = "/dev/ttyS0"

describe CurrentCost::Meter do

  before(:each) do    
    @meter = CurrentCost::Meter.new(TEST_PORT)
  end
  
  after(:each) do
    @meter.close
  end

  it "should allow access to the latest reading after a reading is received" do
    @meter.latest_reading.should be_nil
    @meter.update('<msg><date><dsb>00007</dsb><hr>23</hr><min>14</min><sec>57</sec></date><src><name>CC02</name><id>00077</id><type>1</type><sver>1.06</sver></src><ch1><watts>00365</watts></ch1><ch2><watts>00000</watts></ch2><ch3><watts>00000</watts></ch3><tmpr>23.3</tmpr></msg>')
    @meter.latest_reading.is_a?(CurrentCost::Reading).should be_true
  end
  
  it "should be an Observer" do
    @meter.should respond_to(:update)
  end

  it "should be Observable" do
    @meter.is_a?(Observable).should be_true
  end

  # A mock observer to test meter observable code
  class TestObserver
    def initialize
      @received_reading = false
    end
    def update(reading)
      @received_reading = true if reading.is_a?(CurrentCost::Reading)
    end
    attr_reader :received_reading
  end

  it "should send reading to observers when a valid reading is received" do
    t = TestObserver.new
    @meter.add_observer(t)
    @meter.update('<msg><date><dsb>00007</dsb><hr>23</hr><min>14</min><sec>57</sec></date><src><name>CC02</name><id>00077</id><type>1</type><sver>1.06</sver></src><ch1><watts>00365</watts></ch1><ch2><watts>00000</watts></ch2><ch3><watts>00000</watts></ch3><tmpr>23.3</tmpr></msg>')
    t.received_reading.should be_true
  end

  it "should not notify observers when an invalid reading is received" do
    t = TestObserver.new
    @meter.add_observer(t)
    @meter.update('')
    t.received_reading.should be_false
  end

end
