require_relative '../spec_helper'

describe Simple::Metrics::Timer do
  context "setting a metrics timer" do
    class Samovar
      include Simple::Metrics
      attr_accessor :tea_timer

      def make_tea
        timer("tea time") do |tea_timer|
          @tea_timer = tea_timer
          "Brewing..."
        end
      end
    end

    let(:samovar) { Samovar.new }

    it "should yield a new timer to the block" do
      samovar.make_tea
      samovar.tea_timer.count.should_not be_zero
    end

    it "should create a new timer" do
      samovar.make_tea
      samovar.tea_timer.should be_a_kind_of(Java::ComYammerMetricsCore::Timer)
    end
  end
end
