require 'rocketamf'
require 'rails'

require 'rails3-amf/serialization'
require 'rails3-amf/action_controller'
require 'rails3-amf/configuration'
require 'rails3-amf/request_parser'
require 'rails3-amf/request_processor'

module Rails3AMF
  class Railtie < Rails::Railtie
    config.rails3amf = Rails3AMF::Configuration.new

    initializer "rails3amf.middleware" do
      config.app_middleware.use Rails3AMF::RequestParser, config.rails3amf, Rails.logger
      config.app_middleware.use Rails3AMF::RequestProcessor, config.rails3amf, Rails.logger
    end
  end
end
