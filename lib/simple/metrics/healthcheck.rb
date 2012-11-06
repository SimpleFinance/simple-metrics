java_import com.yammer.metrics.core.HealthCheck

module Simple
  module Metrics
    module Healthchecks
      include Simple::Metrics

      # Create a new healthcheck
      #
      # @param [String] name The name of the healthcheck, eg `check_db`.
      # @return [MetricName] the newly created metric name
      def new_healthcheck(name, &blk)
        healthcheck = Check.new(name, &blk)
        Java::ComYammerMetrics::HealthChecks.register(healthcheck)
        run_healthcheck_loop
      end

      # Run the healthcheck loop
      # This starts a new thread that runs all of the defined healthcheck loops.
      def run_healthcheck_loop
        return if @running_healthcheck_loop
        Thread.new do
          loop do
            run_all_healthchecks
            sleep 5
          end
        end
        @running_healthcheck_loop = true
      end

      # Run all of the healthchecks that have been defined
      def run_all_healthchecks
        Java::ComYammerMetrics::HealthChecks.runHealthChecks
      end
    end

    class Check < Java::ComYammerMetricsCore::HealthCheck
      def initialize(name, &blk)
        super(name)
        @blk = blk
      end

      # Call the block and capture the return value.
      # If the result is `Simple::Metrics::HEALTHY`, mark the healthcheck as healthy.
      # If the result is a `Simple::Metrics::WARNING`, mark the healthcheck in the warning state.
      # If the result is a `Simple::Metrics::UNHEALTHY`, or throws an error,
      # mark the healthcheck as unhealthy.
      def check
        begin
          r = @blk.call
          case (r.is_a?(Class) ? r.new : r)
          when Simple::Metrics::HEALTHY
            Java::ComYammerMetricsCore::HealthCheck::Result.healthy
          when Simple::Metrics::WARNING
            Java::ComYammerMetricsCore::HealthCheck::Result.warning
          when Simple::Metrics::UNHEALTHY
            Java::ComYammerMetricsCore::HealthCheck::Result.unhealthy(r.message)
          end
        rescue StandardError => e
          Java::ComYammerMetricsCore::HealthCheck::Result.unhealthy(e.message)
        end
      end
    end
  end
end
