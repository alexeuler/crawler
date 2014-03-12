require 'rack'
require File.expand_path("../controller", __FILE__)

builder = Rack::Builder.new do
  use Rack::Auth::Basic do |username, password|
    username == App.config.tokens.user && password == App.config.tokens.password
  end
  run Controller.new
end

Rack::Handler::Mongrel.run builder, :Port => App.config.tokens.port
