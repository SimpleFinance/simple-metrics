# -*- encoding: utf-8 -*-
require File.expand_path('../lib/simple/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["dan herrera", "james pozdena"]
  gem.email         = ["dan@simple.com"]
  gem.platform      = 'java'
  gem.description   = %q{A simple JRuby wrapper around codahale's metrics package}
  gem.summary       = %q{MEASURE ALL THE THINGS!}
  gem.homepage      = "https://github.com/SimpleFinance/simple-metrics"
  gem.files         = `git ls-files`.split($\)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "simple-metrics"
  gem.require_paths = ["lib"]
  gem.version       = Simple::Metrics::VERSION

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'yard'
  gem.add_development_dependency 'kramdown'
end
