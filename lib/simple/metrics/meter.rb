module Simple
  module Metrics
    module Meter
      include Simple::Metrics

      # Create a new meter
      #
      # @param [String] name The name of the meter
      # @param [String] klass_name The name of the class, usually the application. Defaults to
      # `self.class.name`
      # @param [TimeUnit] time_unit The rate at which to measure marked data. Defaults to
      # TimeUnit::SECONDS
      def define_meter(name, klass_name = self.class.name, time_unit = Simple::Metrics::DEFAULT_RATE_UNIT)
        type = "meter"
        metric_name = new_metric_name(klass_name, name, type)
        meter = Java::ComYammerMetrics::Metrics.new_meter(metric_name, name.to_s, time_unit)
        define_method("#{name}") do
          meter
        end
      end
    end
  end
end
