require 'spec_helper.rb'

describe "Rails3AMF actionpack additions" do
  it "should have AMF mime type" do
    Mime::AMF.to_s.should == "application/x-amf"
  end

  it "should have amf renderer" do
    ActionController::Renderers::RENDERERS.key?(:amf).should be_true
  end
end