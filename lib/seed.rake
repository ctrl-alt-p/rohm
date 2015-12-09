namespace :seed do
  desc 'Seed Stocks'
  task :stocks do
    Ohm.redis.call "FLUSHALL"
    Rake::Task['seed:stocks_sp500'].execute()
    Rake::Task['seed:stocks_dow_jones_industrial_average'].execute()
    Rake::Task['seed:stocks_nasdaq_composite'].execute()
    Rake::Task['seed:stocks_nasdaq_100'].execute()
    Rake::Task['seed:stocks_nyse_composite'].execute()
    Rake::Task['seed:stocks_ftse_100'].execute()
  end


  desc 'Seed S&P 500 Index Index stocks'
  task :stocks_sp500 do
    Rake::Task['seed:fetch_stocks'].execute(exchange: 'SP500', url: 'https://s3.amazonaws.com/static.quandl.com/tickers/SP500.csv')
  end


  desc 'Seed Dow Jones Industrial Average stocks'
  task :stocks_dow_jones_industrial_average do
    Rake::Task['seed:fetch_stocks'].execute(exchange: 'Dow Jones Industrial Average', url: 'https://s3.amazonaws.com/static.quandl.com/tickers/dowjonesA.csv')
  end


  desc 'Seed NASDAQ Composite Index stocks'
  task :stocks_nasdaq_composite do
    Rake::Task['seed:fetch_stocks'].execute(exchange: 'NASDAQ Composite Index', url: 'https://s3.amazonaws.com/static.quandl.com/tickers/NASDAQComposite.csv')
  end


  desc 'Seed NASDAQ 100 Index stocks'
  task :stocks_nasdaq_100 do
    Rake::Task['seed:fetch_stocks'].execute(exchange: 'NASDAQ 100', url: 'https://s3.amazonaws.com/static.quandl.com/tickers/nasdaq100.csv')
  end


  desc 'Seed NYSE Composite Index stocks'
  task :stocks_nyse_composite do
    Rake::Task['seed:fetch_stocks'].execute(exchange: 'NYSE Composite', url: 'https://s3.amazonaws.com/static.quandl.com/tickers/NYSEComposite.csv')
  end


  desc 'Seed FTSE 100 Index stocks'
  task :stocks_ftse_100 do
    Rake::Task['seed:fetch_stocks'].execute(exchange: 'FTSE 100', url: 'https://s3.amazonaws.com/static.quandl.com/tickers/FTSE100.csv')
  end


  task :fetch_stocks, [:exchange, :url] do |task, args|
    response = Faraday.get(args[:url])
    stocks   = response.body.split("\n")[1..-1].map do |line|
      pieces          = line.split(',')
      stock           = Stock.with(:symbol, pieces[0]) || Stock.new
      stock.symbol    = pieces[0]
      stock.name      = pieces[1..-3].join(',')
      stock.exchanges ||= []
      stock.exchanges << args[:exchange]
      stock.save

      ap stock

      stock
    end

  end
end
