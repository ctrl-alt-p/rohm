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
    progressbar = ProgressBar.create( :format         => '%E | %a %bᗧ%i %p%% %t',
                                      :progress_mark  => ' ',
                                      :remainder_mark => '･',
                                      :starting_at    => 0,
                                      )

    SeedExchanges.new.seed! progressbar
    SeedStocks.new.seed!    progressbar
    SeedOptions.new.seed!   progressbar

    progressbar.finish
  end
end
