namespace :db do
  namespace :seeds do
    desc 'Seed Stocks'
    task :stocks => :environment do
      Ohm.redis.call "FLUSHALL"
      Exchange.all.map(&:destroy)
      Stock.all.map(&:destroy)
      Option.all.map(&:destroy)

      exchanges = {
        sp500:             { name: 'S&P 500 Index Index',          exchange: 'SP500',                         url: 'https://s3.amazonaws.com/static.quandl.com/tickers/SP500.csv'           },
        djia:              { name: 'Dow Jones Industrial Average', exchange: 'Dow Jones Industrial Average',  url: 'https://s3.amazonaws.com/static.quandl.com/tickers/dowjonesA.csv'       },
        nasdaq_composite:  { name: 'NASDAQ Composite Index',       exchange: 'NASDAQ Composite Index',        url: 'https://s3.amazonaws.com/static.quandl.com/tickers/NASDAQComposite.csv' },
        stocks_nasdaq_100: { name: 'NASDAQ 100 Index',             exchange: 'NASDAQ 100',                    url: 'https://s3.amazonaws.com/static.quandl.com/tickers/nasdaq100.csv'       },
        nyse_composite:    { name: 'NYSE Composite Index',         exchange: 'NYSE Composite',                url: 'https://s3.amazonaws.com/static.quandl.com/tickers/NYSEComposite.csv'   },
        ftse_100:          { name: 'FTSE 100 Index',               exchange: 'FTSE 100',                      url: 'https://s3.amazonaws.com/static.quandl.com/tickers/FTSE100.csv'         },
      }
      exchanges.each do |key, hash|
        exchange = Exchange.create(hash.merge(slug: key))
        exchange.populate_stocks
      end
    end
  end
end
