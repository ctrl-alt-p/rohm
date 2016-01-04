module StockHelper
  class SeedData

    def seed_data!
      fetch_quotes! Stock.all
    end

    # Update the quotes for the given stocks
    def fetch_quotes! stocks
      stocks_hash = group_by_symbol(stocks)
      quotes      = stocks_hash.keys.sort.in_groups_of(500, nil).map(&:compact).map { |group| TradierClient.instance.client.quotes group.join(',') }.flatten.compact
      quotes_hash = group_by_symbol(quotes)

      quotes_hash.each do |symbol, quote|
        stock = stocks_hash[symbol]
        raise ArgumentError, "Nil stock for symbol='#{symbol}', quote=#{quote}" if stock.blank?

        stock.update(map_quote_to_stock_attrs(quote))
      end

      self
    end


    # Map the JSON payload from Tradier to the Stock model
    cattr_accessor :maps_quote_to_stock_attrs
    self.maps_quote_to_stock_attrs = {
      last:              nil,
      change:            nil,
      change_percentage: nil,
      volume:            nil,
      average_volume:    nil,
      last_volume:       nil,
      trade_date:        nil,
      open:              nil,
      high:              nil,
      low:               nil,
      close:             nil,
      prevclose:         :prev_close,
      week_52_high:      nil,
      week_52_low:       nil,
      bid:               nil,
      bidsize:           :bid_size,
      bid_date:          nil,
      ask:               nil,
      asksize:           :ask_size,
      ask_date:          nil,
    }

    # Map an instance of the quote to the stock attributes
    def map_quote_to_stock_attrs quote
      output = {}
      quote_hash = Hashie::Mash.new(quote.to_hash)
      maps_quote_to_stock_attrs.each do |quote_field, attr_field|
        stock_field         = attr_field || quote_field
        output[stock_field] = quote_hash[quote_field] == "NaN" ? nil : quote_hash[quote_field]
      end
      output
    end

    # Short-hand helper for grouping symbols & quotes by symbol
    def group_by_symbol array
      array.inject({}) { |hash, value| hash[value.symbol] = value; hash }
    end

  end
end
