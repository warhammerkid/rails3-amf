require File.dirname(__FILE__) + '/spec_helper.rb'

describe Rails3AMF::RequestProcessor do
  class FakeController
    def self.controller_name; 'fake'; end
    def self.action_methods; ['get_user']; end
    def dispatch action_name, request
      [200, {}, ActionDispatch::Response.new]
    end
  end

  before :each do
    @mock_next = mock("Middleware")
    @config = Rails3AMF::Configuration.new
    @app = Rails3AMF::RequestProcessor.new(@mock_next, @config, Logger.new(nil))
    @env = {
      'rails3amf.request' => RocketAMF::Envelope.new(:amf_version => 3),
      'rails3amf.response' => RocketAMF::Envelope.new,
      'rack.input' => StringIO.new
    }
  end

  it "should pass through if not AMF" do
    @mock_next.should_receive(:call).and_return "success"
    @app.call({}).should == "success"
  end

  it "should not allow invalid controller names" do
    lambda {
      @app.get_service("Kernel", "exec")
    }.should raise_error("Service Kernel does not exist")
  end

  it "should not allow invalid actions" do
    lambda {
      @app.get_service("FakeController", "exec")
    }.should raise_error("Service FakeController does not respond to exec")
  end

  it "should properly map parameters to params array" do
    @config.map_params :controller => 'c', :action => 'a', :params => [:session, :second]
    params = @app.build_params 'c', 'a', ["session_id", 42]

    params[0].should == "session_id"
    params[1].should == 42
    params[:session].should == "session_id"
    params[:second].should == 42
  end

  it "should handle AMF request" do
    @env['rails3amf.request'].messages << RocketAMF::Message.new('FakeController.get_user', '/1', [])
    @app.should_receive(:get_service).with('FakeController', 'get_user').and_return(FakeController)
    @app.call(@env)
    @env['rails3amf.response'].constructed?.should be_true
  end

  it "should handle errors in controller properly" do
    @env['rails3amf.request'].messages << RocketAMF::Message.new('FakeController.get_user', '/1', [])
    @app.should_receive(:get_service).with('FakeController', 'get_user').and_return(FakeController)
    c = mock FakeController
    c.stub!(:dispatch) { raise "die" }
    FakeController.should_receive(:new).and_return(c)

    @app.call(@env)

    res_msg = @env['rails3amf.response'].messages[0]
    res_msg.data.should be_a(RocketAMF::Values::ErrorMessage)
    res_msg.data.faultString.should == "die"
  end
end