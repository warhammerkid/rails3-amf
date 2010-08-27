require 'action_controller/railtie'

Mime::Type.register "application/x-amf", :amf

module ActionController
  module Renderers
    add :amf do |amf, options|
      self.content_type ||= Mime::AMF
      self.response_body = amf
    end
  end
end