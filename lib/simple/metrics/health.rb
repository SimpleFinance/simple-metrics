module Simple
  module Metrics
    class Health
      attr_accessor :message

      def initialize(message=nil)
        @message = message
      end
    end

    class HEALTHY < Health;   end
    class UNHEALTHY < Health; end
    class WARNING < Health;   end
  end
end
