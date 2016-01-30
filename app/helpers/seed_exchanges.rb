require 'yaml'

class SeedExchanges
  include ExecutedInSeconds
  attr_reader :exchange_data
  attr_reader :exchanges

  def initialize
    log_run_time "Loading Exchanges" do
      @exchange_data = YAML.load_file(Rails.root.join('db/seed_exchanges.yml'))
      @exchanges     = @exchange_data.map { |hash| Exchange.find_or_create(hash[:slug], hash) }
    end
  end

  # Find/Create the exchanges from the opts hash above:
  def seed!
    log_run_time "Building Exchanges" do
      progressbar = ProgressBar.create( :format         => '%E | %a %bᗧ%i %p%% %t',
                                        :progress_mark  => ' ',
                                        :remainder_mark => '･',
                                        :starting_at    => 0,
                                        :total          => @exchanges.count+1,
                                        :title          => 'Building Exchanges',
                                        )
      progressbar.start
      @exchanges.each do |exchange|
        progressbar.increment
        exchange.reload_data!
      end
      progressbar.finish
    end
  end
end
