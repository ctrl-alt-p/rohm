class Option < Ohm::Model
  attribute :symbol              # Option Symbol
  attribute :description         # Symbol description
  attribute :option_type         # Type of option (Call or Put)
  attribute :exch                # Exchange
  attribute :change_price        # Daily net change
  attribute :change_percentage   # Daily net change
  attribute :volume              # Volume for the day
  attribute :average_volume      # Average daily volume
  attribute :last_price          # Last incremental price
  attribute :last_volume         # Last incremental volume
  attribute :last_trade_date     # Date and time of last trade
  attribute :open_price          # Opening price
  attribute :high_price          # Trading day high
  attribute :low_price           # Trading day low
  attribute :close_price         # Closing price
  attribute :prev_close_price    # Previous closing price
  attribute :price_spread        # Bid/Ask spread
  attribute :bid_price           # Current bid
  attribute :bid_size            # Size of bid
  attribute :bid_exch            # Exchange of bid
  attribute :bid_date            # Date and time of current bid
  attribute :ask_price           # Current ask
  attribute :ask_size            # Size of ask
  attribute :ask_exch            # Exchange of ask
  attribute :ask_date            # Date and time of current ask
  attribute :open_interest       # Open interest
  attribute :underlying          # Underlying symbol
  attribute :strike              # Strike price
  attribute :contract_size       # Size of the contract in shares
  attribute :expiration_date     # Date of expiration
  attribute :expiration_type     # Type of expiration (standard, weekly)
  attribute :days_to_expiration  # Number of days until it expires

  # We are owned by a Stock
  reference :stock, :Stock

  unique :symbol
  index  :symbol
  index  :expiration_date
  index  :days_to_expiration
  index  :strike
  index  :price_spread

  def self.find_or_create(symbol, stock, quote)
    option = Option.find_by_symbol(symbol)
    return option if option.present?

    option = Option.create(symbol: symbol, stock_id: stock.id, strike: quote.strike, expiration_date: quote.expiration_date, option_type: quote.option_type)
    option.quote= quote
    option.save
    option
  end

  def quote= quote
    [:symbol, :description, :option_type, :exch, :change_price, :change_percentage, :volume, :average_volume, :last_price, :last_volume, :last_trade_date, :open_price, :high_price, :low_price, :close_price, :prev_close_price, :bid_price, :bid_size, :bid_exch, :bid_date, :ask_price, :ask_size, :ask_exch, :ask_date, :open_interest, :underlying, :strike, :contract_size, :expiration_date, :expiration_type, :price_spread, :days_to_expiration].each do |field|
      begin
        send("#{field}=", quote.blank? ? nil : quote.send(field))
      rescue StandardError => e
        byebug
        puts field
        puts e.message
        puts e.backtrace.join("\n")
        raise e
      end
    end

    self
  end

  def refresh_data!
    Quote.fetch_data!([self], false)
    self
  end

end
