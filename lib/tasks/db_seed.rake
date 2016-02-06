require 'yaml'

namespace :db do
  desc 'Seed the data'
  task :seed => [:environment, 'db:progressbar'] do
    # Delete the existing data
    Ohm.redis.call "FLUSHDB"

    # Refresh the data
    Rake::Task['db:refresh'].execute
  end

  desc 'Refresh the data'
  task :refresh => [:environment, 'db:progressbar'] do
    Rake::Task['db:refresh_exchanges'].execute
    Rake::Task['db:refresh_stocks'   ].execute
    Rake::Task['db:refresh_options'  ].execute
  end

  desc 'Only refresh the exchanges'
  task :refresh_exchanges => [:environment, 'db:progressbar'] do
    SeedExchanges.new.seed! $progressbar
  end

  desc 'Only refresh the stocks'
  task :refresh_stocks => [:environment, 'db:progressbar'] do
    SeedStocks.new.seed! $progressbar
  end

  desc 'Only refresh the options'
  task :refresh_options => [:environment, 'db:progressbar'] do
    SeedOptions.new.seed! $progressbar
  end



  #
  #
  # Utility helpers:
  #
  #


  # Alias to :refresh
  task :update => ['db:refresh'] do
  end

  # Create the $progressbar global
  task :progressbar do
    $progressbar = ProgressBar.create(
      :format         => '%E | %a %bᗧ%i %p%% %t',
      :progress_mark  => ' ',
      :remainder_mark => '･',
      :starting_at    => 0,
    )
  end

end
