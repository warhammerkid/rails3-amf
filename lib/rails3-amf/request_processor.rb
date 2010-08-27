module Rails3AMF
  class RequestProcessor
    def initialize app, config={}, logger=nil
      @app = app
      @config = config
      @logger = logger || Logger.new(STDERR)
    end

    # Processes the AMF request and forwards the method calls to the corresponding
    # rails controllers. No middleware beyond the request processor will receive
    # anything if the request is a handleable AMF request.
    def call env
      return @app.call(env) unless env['rails3amf.response']

      # Handle each method call
      req = env['rails3amf.request']
      res = env['rails3amf.response']
      res.each_method_call req do |method, args|
        begin
          handle_method method, args, env
        rescue Exception => e
          # Log and re-raise exception
          @logger.error e
          raise e
        end
      end
    end

    def handle_method method, args, env
      path = method.split('.')
      method_name = path.pop
      controller_name = path.pop

      # Get the service
      begin
        # Hopefully the following two checks are enough to prevent hacking...
        raise "not controller" unless controller_name =~ /^[A-Za-z:]+Controller$/
        controller = ActiveSupport::Dependencies.ref(controller_name).get
        raise "not controller" unless controller.respond_to?(:controller_name) && controller.respond_to?(:action_methods)
      rescue Exception => e
        raise "Service #{controller_name} does not exist"
      end
      unless controller.action_methods.include?(method_name)
        raise "Service #{controller_name} does not respond to #{method_name}"
      end

      # Create rack request
      new_env = env.dup
      new_env['HTTP_ACCEPT'] = Mime::AMF.to_s # Force amf response
      req = ActionDispatch::Request.new(new_env)

      # Run it
      response = controller.new.dispatch(method_name, req)
      return response[2].body_parts # Object to serialize is the body of the response
    end
  end
end