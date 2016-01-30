class Stock < Ohm::Model
  attribute :symbol            # Symbol
  attribute :description       # Symbol description
  attribute :security_type     # Type of security (i.e. stock, etf, option, index)
  attribute :change            # Daily net change
  attribute :change_percentage # Daily net change
  attribute :volume            # Volume for the day
  attribute :average_volume    # Average daily volume
  attribute :last_price        # Last incremental volume
  attribute :last_volume       # Last incremental volume
  attribute :last_trade_date   # Date and time of last trade
  attribute :open              # Opening price
  attribute :high              # Trading day high
  attribute :low               # Trading day low
  attribute :close             # Closing price
  attribute :prev_close        # Previous closing price
  attribute :week_52_high      # 52 week high
  attribute :week_52_low       # 52 week low
  attribute :bid_price         # Current bid
  attribute :bid_size          # Size of bid
  attribute :bid_exch          # Exchange of bid
  attribute :bid_date          # Date and time of current bid
  attribute :ask_price         # Current ask
  attribute :ask_size          # Size of ask
  attribute :ask_exch          # Exchange of ask
  attribute :ask_date          # Date and time of current ask

  # Objects we own:
  collection :exchange_to_stocks, :ExchangeToStock
  collection :options,            :Option

  # Index lookups:
  unique    :symbol
  index     :symbol


  def self.find_or_create(symbol, description = nil)
    Stock.with(:symbol, symbol) || Stock.create(symbol: symbol, description: description)
  end

  def refresh_data!
    Quote.fetch_data!([self])
    self
  end

  def refresh_options!
    if volume.to_i == 0 && last_price.to_f == 0.0
      options.map(&:delete)
      return self
    end

    expiration_dates = RetryRequest.retry_request do
      TradierClient.client.expirations(symbol).map { |date| date.strftime("%Y-%m-%d") }
    end

    option_chains    = expiration_dates.map do |expiration_date|
      # Find all the active chains
      chain_symbols = RetryRequest.retry_request do
        TradierClient.client.chains(symbol, expiration: expiration_date).map(&:symbol)
      end

      # Delete any old chains
      options.reject { |option| chain_symbols.include?(option.symbol) }.map(&:delete)

      # Refresh the quotes for the remaining chanins
      output = chain_symbols.map { |symbol| Option.find_or_create(symbol, self, expiration_date, nil) }
      output
    end

    option_chains.flatten!

    # Delete any stale symbols
    chain_symbols = option_chains.map(&:symbol)
    options.reject { |option| chain_symbols.include?(option.symbol) }.map(&:delete)

    Quote.fetch_data!(option_chains)

    self
  end

  def quote= quote
    [:description, :security_type, :change, :change_percentage, :volume, :average_volume, :last_price, :last_volume, :last_trade_date, :open, :high, :low, :close, :prev_close, :week_52_high, :week_52_low, :bid_price, :bid_size, :bid_exch, :bid_date, :ask_price, :ask_size, :ask_exch, :ask_date].each do |field|
      send("#{field}=", quote.blank? ? nil : quote.send(field))
    end
    self
  end

end
