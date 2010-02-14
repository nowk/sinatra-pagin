$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rubygems'
require 'sinatra'
require 'sinatra/pagin'
require 'rack/test'
require 'spec'
require 'spec/autorun'
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