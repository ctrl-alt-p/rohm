class Quote
  attr_accessor :symbol            # Symbol
  attr_accessor :description       # Symbol description
  attr_accessor :exch              # Exchange
  attr_accessor :type              # Type of security (i.e. stock, etf, option, index)
  attr_accessor :change            # Daily net change
  attr_accessor :change_percentage # Daily net change
  attr_accessor :volume            # Volume for the day
  attr_accessor :average_volume    # Average daily volume
  attr_accessor :last              # Last price
  attr_accessor :last_volume       # Last incremental volume
  attr_accessor :trade_date        # Date and time of last trade
  attr_accessor :open              # Opening price
  attr_accessor :high              # Trading day high
  attr_accessor :low               # Trading day low
  attr_accessor :close             # Closing price
  attr_accessor :prevclose         # Previous closing price
  attr_accessor :week_52_high      # 52 week high
  attr_accessor :week_52_low       # 52 week low
  attr_accessor :bid               # Current bid
  attr_accessor :bidsize           # Size of bid
  attr_accessor :bidexch           # Exchange of bid
  attr_accessor :bid_date          # Date and time of current bid
  attr_accessor :ask               # Current ask
  attr_accessor :asksize           # Size of ask
  attr_accessor :askexch           # Exchange of ask
  attr_accessor :ask_date          # Date and time of current ask
  attr_accessor :open_interest     # Open interest
  attr_accessor :underlying        # Underlying symbol
  attr_accessor :strike            # Strike price
  attr_accessor :contract_size     # Size of the contract in shares
  attr_accessor :expiration_date   # Date of expiration
  attr_accessor :expiration_type   # Type of expiration (standard, weekly)
  attr_accessor :option_type       # Type of option (Call or Put)


  #
  # Fetch the data & populate the quotes data
  #
  def self.fetch_data! models
    symbols = models.map(&:symbol)

    max_symbol_length = symbols.map(&:length).max.to_i

    quotes  = symbols.in_groups_of(max_symbol_length < 8 ? 500 : 300, nil).map(&:compact).map { |symbols| fetch_symbols(symbols) }.flatten

    grouped_models = models.inject({}) { |h,v| h[v.symbol] = v; h }
    grouped_quotes = quotes.inject({}) { |h,v| h[v.symbol] = v; h }
    symbols.each do |symbol|
      model = grouped_models[symbol]
      quote = grouped_quotes[symbol]
      model.quote = quote
      model.save
    end

    models
  end

  #
  # Fetch the Quote objects from the feed
  #
  def self.fetch_symbols symbols
    RetryRequest.retry_request do
      TradierClient.client.quotes(symbols.join(",")).compact.map { |data| Quote.new(data) }
    end
  end

  def cast value
    return value if value.present?
    nil
  end

  def cast_to_i value
    return value.to_i if value.present?
    nil
  end

  def cast_to_f value
    return value.to_f if value.present?
    nil
  end

  def cast_date value
    return value.to_i * 1000 if value.present? && value.is_a?(Date)
    cast_to_i(value)
  end

  #
  # Read in the Tradier::Quote object
  #
  def initialize data
    self.symbol=            data[:symbol]
    self.description=       cast(     data.attrs[:description])
    self.exch=              cast(     data.attrs[:exch])
    self.type=              cast(     data.attrs[:type])
    self.change=            cast_to_f(data.attrs[:change])
    self.change_percentage= cast_to_f(data.attrs[:change_percentage])
    self.volume=            cast_to_i(data.attrs[:volume])
    self.average_volume=    cast_to_i(data.attrs[:average_volume])
    self.last_volume=       cast_to_i(data.attrs[:last_volume])
    self.trade_date=        cast_date(data.attrs[:trade_date])
    self.open=              cast_to_f(data.attrs[:open])
    self.high=              cast_to_f(data.attrs[:high])
    self.low=               cast_to_f(data.attrs[:low])
    self.close=             cast_to_f(data.attrs[:close])
    self.prevclose=         cast_to_f(data.attrs[:prevclose])
    self.week_52_high=      cast_to_f(data.attrs[:week_52_high])
    self.week_52_low=       cast_to_f(data.attrs[:week_52_low])
    self.bid=               cast_to_f(data.attrs[:bid])
    self.bidsize=           cast_to_i(data.attrs[:bidsize])
    self.bidexch=           cast(     data.attrs[:bidexch])
    self.bid_date=          cast_date(data.attrs[:bid_date])
    self.ask=               cast_to_f(data.attrs[:ask])
    self.asksize=           cast_to_i(data.attrs[:asksize])
    self.askexch=           cast(     data.attrs[:askexch])
    self.ask_date=          cast_date(data.attrs[:ask_date])
    self.open_interest=     cast_to_i(data.attrs[:open_interest])
    self.underlying=        cast(     data.attrs[:underlying])
    self.strike=            cast_to_f(data.attrs[:strike])
    self.contract_size=     cast_to_i(data.attrs[:contract_size])
    self.expiration_date=   cast(     data.attrs[:expiration_date])
    self.expiration_type=   cast(     data.attrs[:expiration_type])
    self.option_type=       cast(     data.attrs[:option_type])

    puts data.attrs[:expiration_date] if data[:underlying].present?
  end


  #
  # Friendly aliases
  #
  def open_price;          open;      end
  def high_price;          high;      end
  def low_price;           low;       end
  def close_price;         close;     end
  def prev_close_price;    prev_close;end
  def bid_price;           bid;       end
  def bid_size;            bidsize;   end
  def bid_exch;            bidexch;   end
  def ask_price;           ask;       end
  def ask_size;            asksize;   end
  def ask_exch;            askexch;   end
  def last_price;          last;      end
  def last_trade_date;     trade_date;end
  def prev_close;          prevclose; end
  def security_type;       type;      end
  def change_price;        change;    end

  def price_spread
    return nil if ask_price.blank?
    return nil if bid_price.blank?
    ask_price - bid_price
  end

  def days_to_expiration
    return nil if expiration_date.blank?
    business_days_between(Time.now.to_date, Time.parse(expiration_date).to_date)
  end


  # Name of the attached exchange
  def exchange_name
    underlying.present? ? OptionExchangeCodes.find(exch) : StockExchangeCodes.find(exch)
  end


  # Calculates the number of business days in range (start_date, end_date]
  #
  # @param start_date [Date]
  # @param end_date [Date]
  #
  # @return [Fixnum]
  def business_days_between(start_date, end_date)
    days_between = (end_date - start_date).to_i
    return 0 unless days_between > 0

    # Assuming we need to calculate days from 9th to 25th, 10-23 are covered
    # by whole weeks, and 24-25 are extra days.
    #
    # Su Mo Tu We Th Fr Sa    # Su Mo Tu We Th Fr Sa
    #        1  2  3  4  5    #        1  2  3  4  5
    #  6  7  8  9 10 11 12    #  6  7  8  9 ww ww ww
    # 13 14 15 16 17 18 19    # ww ww ww ww ww ww ww
    # 20 21 22 23 24 25 26    # ww ww ww ww ed ed 26
    # 27 28 29 30 31          # 27 28 29 30 31
    whole_weeks, extra_days = days_between.divmod(7)

    unless extra_days.zero?
      # Extra days start from the week day next to start_day,
      # and end on end_date's week date. The position of the
      # start date in a week can be either before (the left calendar)
      # or after (the right one) the end date.
      #
      # Su Mo Tu We Th Fr Sa    # Su Mo Tu We Th Fr Sa
      #        1  2  3  4  5    #        1  2  3  4  5
      #  6  7  8  9 10 11 12    #  6  7  8  9 10 11 12
      # ## ## ## ## 17 18 19    # 13 14 15 16 ## ## ##
      # 20 21 22 23 24 25 26    # ## 21 22 23 24 25 26
      # 27 28 29 30 31          # 27 28 29 30 31
      #
      # If some of the extra_days fall on a weekend, they need to be subtracted.
      # In the first case only corner days can be days off,
      # and in the second case there are indeed two such days.
      extra_days -= if start_date.tomorrow.wday <= end_date.wday
        [start_date.tomorrow.sunday?, end_date.saturday?].count(true)
      else
        2
      end
    end

    (whole_weeks * 5) + extra_days
  end

end
