require 'java/metrics-graphite-2.1.1'

java_import com.yammer.metrics.reporting.GraphiteReporter

module Simple
  module Metrics
    module Graphite
      # Enable reporting directly to graphite
      #
      # @param [String] server_name The hostname of the graphite server.
      # @param [Int] server_port The port that graphite is running on.
      # @param [String] prefix The prefix to store the data under, eg: `services.development`.
      #                 The class name, or name of the application will be appended:
      #                 `services.development.teatime`
      # @param [Int] interval_in_seconds Time interval for sending to graphite in seconds.
      #              (Defaults to 1 sec)
      def enable_graphite_reporter(server_name, server_port, prefix, interval_in_seconds = 60)
        GraphiteReporter.enable(interval_in_seconds, TimeUnit::SECONDS,
                                server_name, server_port, prefix)
      end
    end
  end
end
