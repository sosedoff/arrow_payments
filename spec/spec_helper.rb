$:.unshift File.expand_path("../..", __FILE__)

require 'webmock'
require 'webmock/rspec'
require 'json'
require 'lib/arrow_payments'

def fixture_path(filename=nil)
  path = File.expand_path("../fixtures", __FILE__)
  filename.nil? ? path : File.join(path, filename)
end

def fixture(file)
  File.read(File.join(fixture_path, file))
end

def json_fixture(file)
  JSON.parse(fixture(file))
end