# app.rb
require "rubygems"
require "ohm"
require "tradier"
require "faraday"

module Tradier
  attr_accessor :client
end

# Configure our connections:
Ohm.redis      = Redic.new("redis://127.0.0.1:6379")
Tradier.client = Tradier::Client.new(access_token: ENV['TRADIER_TOKEN'])

# Load up the app models:
require_relative "./app/stock"
require_relative "./app/option"
