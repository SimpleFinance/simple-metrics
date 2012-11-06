module Simple
  module Metrics
    class RackMetrics
      extend Simple::Metrics::Meter

      # Rack middleware for capturing response codes
      #
      # Creates a series of response meters that will be marked based on the response
      # code that is returned by rack.
      # @param [Object] app Rack application
      # @param [String] application_name The name of the application
      def initialize(app, application_name)
        @app = app

        self.class.define_meter '2xx-responses', application_name
        self.class.define_meter '3xx-responses', application_name
        self.class.define_meter '4xx-responses', application_name
        self.class.define_meter '5xx-responses', application_name
      end

      def call(env)
        begin
          status, headers, body = @app.call(env)
        ensure
          status_code = (status ||= 500).to_s[0]
          status_method = "#{status_code}xx-responses".to_sym
          self.send(status_method).mark
        end
      end
    end
  end
end
