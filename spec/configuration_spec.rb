require 'spec_helper.rb'

describe Rails3AMF::Configuration do
  before :each do
    @config = Rails3AMF::Configuration.new
  end

  it "should default gateway_path to '/amf'" do
    @config.gateway_path.should == "/amf"
  end

  it "should allow updating gateway_path" do
    @config.gateway_path = "/rubyamf/gateway"
    @config.gateway_path.should == "/rubyamf/gateway"
  end

  it "should allow simple class mapping modifications" do
    @config.class_mapping do |m|
      m.map :ruby => "TestRuby", :as => "TestAS"
    end
    RocketAMF::ClassMapper.get_as_class_name("TestRuby").should == "TestAS"
    RocketAMF::ClassMapper.reset
  end

  it "should store parameter mappings" do
    @config.map_params :controller => "UserController", :action => "get_user", :params => [:param1, :param2]
    params = @config.mapped_params "UserController", "get_user", ["asdf", "fdsa"]
    params.should == {:param1 => "asdf", :param2 => "fdsa"}
  end
end