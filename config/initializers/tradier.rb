class TradierClient
  include Singleton
  attr_accessor :client
end

# Configure our connections:
TradierClient.instance.client = Tradier::Client.new(access_token: ENV['TRADIER_TOKEN'])
