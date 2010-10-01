require 'spec_helper.rb'

describe Rails3AMF::RequestParser do
  before :each do
    @mock_next = mock("Middleware")
    @config = Rails3AMF::Configuration.new
    @app = Rails3AMF::RequestParser.new(@mock_next, @config, Logger.new(nil))
    @env = {
      'PATH_INFO' => '/amf',
      'CONTENT_TYPE' => Mime::AMF.to_s,
      'rack.input' => StringIO.new(RocketAMF::Envelope.new.to_s)
    }
  end

  it "should only handle requests with proper content type" do
    @app.should_handle?(@env).should be_true

    @env['CONTENT_TYPE'] = 'text/html'
    @app.should_handle?(@env).should be_false
  end

  it "should only handle requests with proper gateway path" do
    @app.should_handle?(@env).should be_true

    @config.gateway_path = "/invalide"
    @app.should_handle?(@env).should be_false
  end

  it "should pass through requests that aren't AMF" do
    @mock_next.should_receive(:call).and_return("success")
    @app.stub!(:should_handle?).and_return(false)
    @app.call(@env).should == "success"
  end

  it "should serialize to AMF if the response is constructed" do
    @mock_next.stub!(:call) {|env| env['rails3amf.response'].should_receive('constructed?').and_return(true)}
    response = @app.call(@env)
    response[1]["Content-Type"].should == Mime::AMF
  end
end