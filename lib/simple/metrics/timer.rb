module Simple
  module Metrics
    module Timer
      # Create creates a new timer, registers it with the metrics registry,
      # yields the timer to the block and stops it when the block returns.
      #
      # @param [String] name The name of the timer.
      def timer(name)
        metric_name = new_metric_name(sanitize_classname(self.class.name), name, "timer")
        new_timer = metrics_registry.newTimer(metric_name,
                                              DEFAULT_DURATION_UNIT,
                                              DEFAULT_RATE_UNIT)
        captured_timer = new_timer.time
        begin
          yield new_timer
        ensure
          captured_timer.stop
        end
      end
    end
  end
end
