require File.dirname(__FILE__) + '/spec_helper.rb'

describe CurrentCost::Reading do
  
  it "should include date information" do
    CurrentCost::Reading.new.should respond_to(:days_since_birth)
    CurrentCost::Reading.new.should respond_to(:hour)
    CurrentCost::Reading.new.should respond_to(:minute)
    CurrentCost::Reading.new.should respond_to(:second)
  end
  
  it "should include meter identification data" do
    CurrentCost::Reading.new.should respond_to(:name)
    CurrentCost::Reading.new.should respond_to(:id)
    CurrentCost::Reading.new.should respond_to(:type)
    CurrentCost::Reading.new.should respond_to(:software_version)
  end

  it "should include channel measurements" do
    CurrentCost::Reading.new.should respond_to(:channels)
  end

  it "should include temperature" do
    CurrentCost::Reading.new.should respond_to(:temperature)
  end

  it "can include historical data" do
    CurrentCost::Reading.new.should respond_to(:history)
  end

  it "should parse basic data from meter XML output" do
    xml = "<msg><date><dsb>00007</dsb><hr>23</hr><min>14</min><sec>57</sec></date><src><name>CC02</name><id>00077</id><type>1</type><sver>1.06</sver></src><ch1><watts>00365</watts></ch1><ch2><watts>00000</watts></ch2><ch3><watts>00000</watts></ch3><tmpr>23.3</tmpr></msg>"
    r = CurrentCost::Reading.from_xml(xml)
    r.days_since_birth.should be(7)
    r.hour.should be(23)
    r.minute.should be(14)
    r.second.should be(57)
    r.name.should == "CC02"
    r.id.should == "00077"
    r.type.should == "1"
    r.software_version.should == "1.06"
    r.temperature.should == 23.3
    r.channels.size.should be(3)
    r.channels[0][:watts].should be(365)
    r.channels[1][:watts].should be(0)
    r.channels[2][:watts].should be(0)
    r.history.should be_nil
  end

  it "should parse history from meter XML output" do
    float_tolerance = 0.000001
    xml = "<msg><date><dsb>00007</dsb><hr>23</hr><min>13</min><sec>14</sec></date><src><name>CC02</name><id>00077</id><type>1</type><sver>1.06</sver></src><ch1><watts>00357</watts></ch1><ch2><watts>00000</watts></ch2><ch3><watts>00000</watts></ch3><tmpr>23.2</tmpr><hist><hrs><h02>000.0</h02><h04>002.1</h04><h06>001.9</h06><h08>001.1</h08><h10>000.5</h10><h12>000.6</h12><h14>000.6</h14><h16>001.0</h16><h18>000.5</h18><h20>000.3</h20><h22>000.3</h22><h24>000.3</h24><h26>000.3</h26></hrs><days><d01>0010</d01><d02>0013</d02><d03>0003</d03><d04>0004</d04><d05>0012</d05><d06>0008</d06><d07>0005</d07><d08>0000</d08><d09>0000</d09><d10>0000</d10><d11>0000</d11><d12>0000</d12><d13>0000</d13><d14>0000</d14><d15>0000</d15><d16>0000</d16><d17>0000</d17><d18>0000</d18><d19>0000</d19><d20>0000</d20><d21>0000</d21><d22>0000</d22><d23>0000</d23><d24>0000</d24><d25>0000</d25><d26>0000</d26><d27>0000</d27><d28>0000</d28><d29>0000</d29><d30>0000</d30><d31>0000</d31></days><mths><m01>0001</m01><m02>0090</m02><m03>0000</m03><m04>0000</m04><m05>0000</m05><m06>0000</m06><m07>0000</m07><m08>0000</m08><m09>0000</m09><m10>0000</m10><m11>0000</m11><m12>00047</m12></mths><yrs><y1>0000010</y1><y2>0000000</y2><y3>0000000</y3><y4>0000600</y4></yrs></hist></msg>"
    r = CurrentCost::Reading.from_xml(xml)    
    r.history.should_not be_nil
    r.history[:hours].size.should be(27)    
    r.history[:hours][2].should be_close(0.0, float_tolerance)
    r.history[:hours][4].should be_close(2.1, float_tolerance)
    r.history[:hours][6].should be_close(1.9, float_tolerance)
    r.history[:hours][26].should be_close(0.3, float_tolerance)
    r.history[:days].size.should be(32)
    r.history[:days][1].should be(10)
    r.history[:days][2].should be(13)
    r.history[:days][31].should be(0)
    r.history[:months].size.should be(13)
    r.history[:months][1].should be(1)
    r.history[:months][2].should be(90)
    r.history[:months][12].should be(47)
    r.history[:years].size.should be(5)
    r.history[:years][1].should be(10)
    r.history[:years][4].should be(600)
  end

  it "should parse basic data from CC128 output" do
    xml = "<msg><src>CC128-v0.11</src><dsb>00005</dsb><time>08:27:51</time><tmpr>14.8</tmpr><sensor>0</sensor><id>00077</id><type>1</type><ch1><watts>00349</watts></ch1></msg>"
    r = CurrentCost::Reading.from_xml(xml)
    r.days_since_birth.should be(5)
    r.hour.should be(8)
    r.minute.should be(27)
    r.second.should be(51)
    r.id.should == "00077"
    r.type.should == "1"
    r.software_version.should == "CC128-v0.11"
    r.temperature.should == 14.8
    r.channels.size.should be(1)
    r.channels[0][:watts].should be(349)
    r.history.should be_nil
  end

  it "should throw an error if parsing fails" do
    xml = ""
    lambda {
      r = CurrentCost::Reading.from_xml(xml)
    }.should raise_error(CurrentCost::ParseError, "Couldn't parse XML data.")
  end
  
end