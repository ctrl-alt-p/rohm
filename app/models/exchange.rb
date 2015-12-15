class Exchange < Ohm::Model
  # Attributes of our model
  attribute :slug
  attribute :exchange
  attribute :name
  attribute :url
  attribute :symbols

  # Index lookups:
  unique    :slug
  index     :slug


  # Seed data for the exchanges
  cattr_accessor :exchanges_opts
  self.exchanges_opts = {
    sp500:             { name: 'S&P 500 Index Index',          exchange: 'SP500',                         url: 'https://s3.amazonaws.com/static.quandl.com/tickers/SP500.csv'           },
    djia:              { name: 'Dow Jones Industrial Average', exchange: 'Dow Jones Industrial Average',  url: 'https://s3.amazonaws.com/static.quandl.com/tickers/dowjonesA.csv'       },
    nasdaq_composite:  { name: 'NASDAQ Composite Index',       exchange: 'NASDAQ Composite Index',        url: 'https://s3.amazonaws.com/static.quandl.com/tickers/NASDAQComposite.csv' },
    stocks_nasdaq_100: { name: 'NASDAQ 100 Index',             exchange: 'NASDAQ 100',                    url: 'https://s3.amazonaws.com/static.quandl.com/tickers/nasdaq100.csv'       },
    nyse_composite:    { name: 'NYSE Composite Index',         exchange: 'NYSE Composite',                url: 'https://s3.amazonaws.com/static.quandl.com/tickers/NYSEComposite.csv'   },
    ftse_100:          { name: 'FTSE 100 Index',               exchange: 'FTSE 100',                      url: 'https://s3.amazonaws.com/static.quandl.com/tickers/FTSE100.csv'         },
  }


  # Find/Create the exchanges from the opts hash above:
  def self.load_exchanges
    output     = exchanges_opts.map do |slug, hash|
      # Load the symbols from the CSV url
      stocks = Faraday.get(hash[:url]).body.split("\n")[1..-1].map do |line|
        symbol          = line.split(',').first.strip
        stock           = Stock.with(:symbol, symbol) || Stock.new(symbol: symbol)
        stock.name      = line.split(',')[1..-3].join(',')
        stock.exchanges = [stock.exchanges.to_s.split(','), slug].flatten.uniq.join(',')
        stock
      end
      hash[:stocks] = stocks.map(&:symbol).join(',')

      # Load/Create the exchange
      exchange = Exchange.with(:slug, slug) || Exchange.new(slug: slug)

      # Update the exchange with the seed data:
      exchange.update(hash)
      Rails.logger.debug { "Loaded Exchange: slug=#{exchange.slug}, name=#{exchange.name}" }

      # Return the exchange
      exchange
    end
    output
  end


end
