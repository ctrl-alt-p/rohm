namespace :db do
  desc 'Seed the data'
  task :seed => :environment do
    #
    # Delete the existing data
    #
    Ohm.redis.call "FLUSHDB"

    #
    # Re-seed the exchange and stock data
    #
    ExchangeHelper::SeedData.new.seed_data!
    StockHelper::SeedData.new.seed_data!
  end
end
