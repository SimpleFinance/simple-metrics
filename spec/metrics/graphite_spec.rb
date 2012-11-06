require 'spec_helper'

describe Simple::Metrics do
  class GraphiteSpec
    extend Simple::Metrics::Graphite

    enable_graphite_reporter('graphite.example.com', 2003, 'example.class')
  end
end
