# Simple::Metrics

A simple JRuby wrapper around Coda's excellent <a href="http://metrics.codahale.com/">Metrics package</a>

## Installation

Add this line to your application's Gemfile:

    gem 'simple-metrics'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simple-metrics

## Healthchecks

Monitor the health of your application in a granular way.

In a Sinatra/Padrino app, register healthchecks as an extension like so:

    register Simple::Metrics::Healthchecks

To register a new healthcheck:

    class NurseRatched
      extend Simple::Metrics::Healthchecks

      attr_accessor :temp

      new_healthcheck("temperature") do
        if @temp = 98
          Simple::Metrics::HEALTHY
        elsif @temp > 101
          Simple::Metrics::UNHEALTHY.new("Fever!")
        else
          Simple::Metrics::WARNING
        end
      end
    end

Run all healthchecks:

    NurseRatched.run_all_healthchecks

Your healthchecks will be run in a separate thread every 5 seconds. This is a great way to monitor the health of your db connections, thread pools and connections to queues.

If you are running the servlet in a warbler .war file (see example below), you can monitor the overall health of your application with nagios or other monitoring tools.

## Timers

From: <a href="http://metrics.codahale.com/getting-started/#timers">Timers</a>:

A timer measures both the rate that a particular piece of code is called and the distribution of its duration.

    class Samovar
      include Simple::Metrics

      def buh
        timer("tea time") do
          "Brewing..."
        end
      end
    end

## Meters

From: <a href="http://metrics.codahale.com/getting-started/#meters">Meters</a>:

"A meter measures the rate of events over time (e.g., “requests per second”). In addition to the mean rate, meters also track 1-, 5-, and 15-minute moving averages."

    class Rdio
      extend Simple::Metrics::Meter

      define_meter :bump

      def bump_dat
        bump_meter.mark
      end
    end

## Send metrics directly to graphite
   
In a Sinatra app:

    register Simple::Metrics::Graphite

    enable_graphite_reporter("graphite.example.com", 2003, "services.#{RACK_ENV}")

## Exposing metrics from within your app

In order to view/collect the health and metrics of your application from the web, you'll need to add the servlet endpoints.
For this example, I'm using <a href="https://github.com/jruby/warbler">Warbler</a> to package
the application as a .war

In config/web.xml, add the following servlet mappings:

      <servlet>
        <servlet-name>metrics.MetricsServlet</servlet-name>
        <servlet-class>com.yammer.metrics.reporting.MetricsServlet</servlet-class>
      </servlet>
      <servlet-mapping>
        <servlet-name>metrics.MetricsServlet</servlet-name>
        <url-pattern>/metrics</url-pattern>
      </servlet-mapping>

      <servlet>
        <servlet-name>metrics.HealthCheckServlet</servlet-name>
        <servlet-class>com.yammer.metrics.reporting.HealthCheckServlet</servlet-class>
      </servlet>
      <servlet-mapping>
        <servlet-name>metrics.HealthCheckServlet</servlet-name>
        <url-pattern>/healthcheck</url-pattern>
      </servlet-mapping>

      <servlet>
        <servlet-name>metrics.ThreadDumpServlet</servlet-name>
        <servlet-class>com.yammer.metrics.reporting.ThreadDumpServlet</servlet-class>
        <url-pattern>/threads</url-pattern>
      </servlet>

      <servlet>
        <servlet-name>metrics.PingServlet</servlet-name>
        <servlet-class>com.yammer.metrics.reporting.PingServlet</servlet-class>
      </servlet>
      <servlet-mapping>
        <servlet-name>metrics.PingServlet</servlet-name>
        <url-pattern>/ping</url-pattern>
      </servlet-mapping>

Now you can visit your application and get a thread dump, health check or collect metrics using collectd:

    > curl localhost:9292/threads
      main id=1 state=WAITING
      - waiting on <0x073772c5> (a java.lang.Object)
      - locked <0x073772c5> (a java.lang.Object)
      at java.lang.Object.wait(Native Method)