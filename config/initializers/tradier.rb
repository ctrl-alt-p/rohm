require 'tradier'

#
# Singleton wrapper around the Tradier::Client
#
class TradierClient
  include Singleton
  attr_accessor :client

  def self.client
    self.instance.client
  end

  def self.client= value
    self.instance.client = value
  end
end


#
## Un-comment this to enabled detailed logging:
#
module Tradier
  class Client

    def connection
      @connection ||= begin
        connection_options = {:builder => @middleware}
        Faraday.new(@endpoint, @connection_options.merge(connection_options)) do |faraday|
          # faraday.response :detailed_logger
        end
      end
    end
  end
end


# Configure our connections:
TradierClient.client = Tradier::Client.new(access_token: ENV['TRADIER_TOKEN'])
