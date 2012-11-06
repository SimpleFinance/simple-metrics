require 'spec_helper'

describe Simple::Metrics do
  class Rdio
    extend Simple::Metrics::Meter

    define_meter :bump_meter

    def bump_dat
      bump_meter.mark
    end
  end

  let(:rdio) { Rdio.new }

  it "should increment a meter" do
    rdio.bump_dat
    rdio.bump_meter.count.should == 1
  end
end
