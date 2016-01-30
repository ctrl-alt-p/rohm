require 'yaml'

namespace :db do
  desc 'Seed the data'
  task :seed => :environment do
    # Delete the existing data
    Ohm.redis.call "FLUSHDB"

    # Refresh the data
    Rake::Task['db:refresh'].execute
  end

  desc 'Refresh the data'
  task :refresh => :environment do
    SeedExchanges.new.seed!
    SeedStocks.new.seed!
  end
end
