require File.expand_path('../lib/arrow_payments/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = "arrow_payments"
  s.version     = ArrowPayments::VERSION.dup
  s.summary     = "Ruby wrapper for ArrowPayments gateway"
  s.description = "Ruby wrapper for ArrowPayments gateway"
  s.homepage    = "http://github.com/sosedoff/arrow_payments"
  s.authors     = ["Dan Sosedoff"]
  s.email       = ["dan.sosedoff@gmail.com"]
  
  s.add_development_dependency 'webmock',   '~> 1.6'
  s.add_development_dependency 'rake',      '~> 0.9'
  s.add_development_dependency 'rspec',     '~> 2.12'
  
  s.add_runtime_dependency 'faraday',            '~> 0.8'
  s.add_runtime_dependency 'faraday_middleware', '~> 0.8'
  s.add_runtime_dependency 'hashie',             '~> 2.0'
  s.add_runtime_dependency 'json',               '~> 1.7'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{|f| File.basename(f)}
  s.require_paths = ["lib"]
end