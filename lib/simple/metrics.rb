require 'java'
require 'java/metrics-core-2.1.1'
require 'java/slf4j-api-1.6.4'
require 'java/jackson-core-asl-1.9.5'
require 'java/jackson-mapper-asl-1.9.5'
require 'java/metrics-servlet-2.1.1'

require_relative 'metrics/timer'
require_relative 'metrics/meter'
require_relative 'metrics/healthcheck'
require_relative 'metrics/health'
require_relative 'metrics/graphite'

java_import java.util.concurrent.TimeUnit
java_import com.yammer.metrics.Metrics
java_import com.yammer.metrics.core.MetricName

module Simple
  module Metrics
    DEFAULT_DURATION_UNIT = TimeUnit::MILLISECONDS
    DEFAULT_RATE_UNIT     = TimeUnit::SECONDS
    DEFAULT_TIMING_UNIT   = TimeUnit::NANOSECONDS

    include Timer

    # Sanitize classnames for graphite
    #
    # @param [Object] klass_name The request object
    # @return [String] The class name without colons
    def sanitize_classname(klass_name)
      klass_name.gsub(":","")
    end

    # The default metrics registry
    #
    # @return [Java::ComYammerMetrics::Metrics] the default metrics registry
    def metrics_registry
      Java::ComYammerMetrics::Metrics.defaultRegistry
    end

    # Create a new metric name
    #
    # @param [String] klass_name The name of the class, usually the application name
    # @param [String] name The name of the metric
    # @param [String] type The type of metric
    # @return [MetricName] the newly created metric name
    def new_metric_name(klass_name, name, type)
      MetricName.new(klass_name.downcase, type, name.to_s)
    end
  end
end
