require 'rubygems'
require 'spec'
require 'rack/test'
require "webrat"
#require 'mocha'

Webrat.configure do |config|
  config.mode = :rack
end

Spec::Runner.configure do |config|
  config.include Rack::Test::Methods
  config.include Webrat::Methods
  config.include Webrat::Matchers
  # config.mock_with :mocha
end