namespace :seed do
  desc 'Seed Stocks'
  task :stocks do
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
    require_relative File.expand_path( "#{ File.dirname(__FILE__) }/../app" )
    require 'csv'

    response = Faraday.get(args[:url])
    keys = nil
    rows = []
    CSV.parse(response.body) do |row|
      if keys.nil?
        keys = row
      else
        rows << Hash[ keys.zip(row) ]
      end
    end

    rows.each do |hash|
      stock          = Stock[hash['ticker']] || Stock.create(id: hash['ticker'])
      stock.name     = hash['ticker']
      stock.exchange = args[:exchange]
      stock.save
    end
  end
end
