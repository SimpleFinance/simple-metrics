require 'spec_helper'

describe Simple::Metrics::Healthchecks do
  it "should register a new healthcheck" do
    class NurseRatched
      extend Simple::Metrics::Healthchecks

      class << self
        def status=(v)
          @status = v
        end
        def status
          @status
        end
      end

      self.status = "healthy"

      new_healthcheck("temperature") do
        case self.status
        when "healthy"
          Simple::Metrics::HEALTHY
        when "unhealthy"
          Simple::Metrics::UNHEALTHY.new("Too Many Tacos!")
        when "dead"
          raise "Pants"
        end
      end
    end
  end

  it "should run all healthchecks" do
    NurseRatched.status = "healthy"
    NurseRatched.run_all_healthchecks.entrySet.each do |result|
      result.getValue.isHealthy.should be_true
    end
  end

  it "should return the last error message when unhealthy" do
    NurseRatched.status = "unhealthy"
    NurseRatched.run_all_healthchecks.entrySet.each do |result|
      result.getValue.isHealthy.should be_false
      result.getValue.getMessage.should == "Too Many Tacos!"
    end
  end

  it "should return an unhealthy if the check raises an error" do
    NurseRatched.status = "dead"
    NurseRatched.run_all_healthchecks.entrySet.each do |result|
      result.getValue.isHealthy.should be_false
      result.getValue.getMessage.should == "Pants"
    end
  end

end
